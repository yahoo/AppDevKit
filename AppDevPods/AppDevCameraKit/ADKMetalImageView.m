//
//  ADKMetalImageView.m
//  AppDevKit
//
//  Created by  Chih Feng Sung on 12/11/18.
//  Copyright © 2018 Yahoo. All rights reserved.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKMetalImageView.h"

@interface ADKMetalImageView()

@property (strong, nonatomic) CIContext *ciContext;
@property (strong, nonatomic) id<MTLCommandQueue> commandQueue;

@end


@implementation ADKMetalImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();

    NSAssert(device && [device supportsFeatureSet:MTLFeatureSet_iOS_GPUFamily1_v1], @"The device doesn't support Metal rendering");
    self = [self initWithFrame:frame device:device];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frameRect device:(id<MTLDevice>)device
{
    if (self = [super initWithFrame:frameRect device:device]) {
        self.ciContext = [CIContext contextWithMTLDevice:device options:@{kCIContextUseSoftwareRenderer:@NO}];
        self.commandQueue = [device newCommandQueue];

        self.framebufferOnly = NO;
        self.enableSetNeedsDisplay = NO;
        self.paused = YES;
        self.clearColor = MTLClearColorMake(0, 0, 0, 0);
    }

    return self;
}

- (void)setImage:(CIImage *)image
{
    _image = image;

    [self draw];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    CGFloat redColor;
    CGFloat greenColor;
    CGFloat blueColor;
    CGFloat alphaColor;
    [backgroundColor getRed:&redColor green:&greenColor blue:&blueColor alpha:&alphaColor];

    self.clearColor = MTLClearColorMake(redColor, greenColor, blueColor, alphaColor);

    [self draw];
}

- (UIColor *)backgroundColor
{
    CGFloat redColor = (CGFloat)self.clearColor.red;
    CGFloat greenColor = (CGFloat)self.clearColor.green;
    CGFloat blueColor = (CGFloat)self.clearColor.blue;
    CGFloat alphaColor = (CGFloat)self.clearColor.alpha;

    return [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alphaColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self draw];
}

- (void)draw
{
    CGRect drawRect;
    CGRect drawableRect;
    CIImage *drawImage;
    id<MTLCommandBuffer> commandBuffer = self.commandQueue.commandBuffer;
    id<MTLTexture> texture;
    MTLRenderPassDescriptor *renderPassDescroptor = self.currentRenderPassDescriptor;
    CGColorSpaceRef colorSpaceRef = self.image.colorSpace;

#if !TARGET_IPHONE_SIMULATOR
    texture = self.currentDrawable.texture;
#endif

    id <MTLRenderCommandEncoder> renderCommandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescroptor];
    [renderCommandEncoder endEncoding];

    drawableRect = CGRectMake(0.0f, 0.0f, self.drawableSize.width, self.drawableSize.height);
    drawImage = self.image;

    switch (self.contentMode) {
        case ADKMetalImageViewContentModeScaleAspectFit:{
            CGFloat scale = MIN(CGRectGetWidth(drawableRect) / CGRectGetWidth(self.image.extent), CGRectGetHeight(drawableRect) / CGRectGetHeight(self.image.extent));
            CGAffineTransform applyedTransform = CGAffineTransformMakeScale(scale, scale);
            drawImage = [self.image imageByApplyingTransform:applyedTransform];
            drawRect = [self alignLeftFromRect:drawImage.extent toRect:drawableRect];
            break;
        }
        case ADKMetalImageViewContentModeScaleAspectFill:{
            CGFloat scale = MAX(CGRectGetWidth(drawableRect) / CGRectGetWidth(self.image.extent), CGRectGetHeight(drawableRect) / CGRectGetHeight(self.image.extent));
            CGAffineTransform applyedTransform = CGAffineTransformMakeScale(scale, scale);
            drawImage = [self.image imageByApplyingTransform:applyedTransform];
            drawRect = [self alignCenterFromRect:drawImage.extent toRect:drawableRect];
            break;
        }
        case ADKMetalImageViewContentModeCenter:
            drawRect = [self alignCenterFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeTop:
            drawRect = [self alignTopFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeBottom:
            drawRect = [self alignBottomFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeLeft:
            drawRect = [self alignLeftFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeRight:
            drawRect = [self alignRightFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeTopLeft:
            drawRect = [self alignTopLeftFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeTopRight:
            drawRect = [self alignTopRightFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeBottomLeft:
            drawRect = [self alignBottomLeftFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeBottomRight:
            drawRect = [self alignBottomRightFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKMetalImageViewContentModeScaleToFill:
        default:{
            CGAffineTransform applyedTransform = CGAffineTransformMakeScale(CGRectGetWidth(drawableRect) / CGRectGetWidth(self.image.extent), CGRectGetHeight(drawableRect) / CGRectGetHeight(self.image.extent));
            drawImage = [self.image imageByApplyingTransform:applyedTransform];
            drawRect = drawableRect;
            break;
        }
    }

    [self.ciContext render:drawImage toMTLTexture:texture commandBuffer:commandBuffer bounds:drawRect colorSpace:colorSpaceRef];

    [commandBuffer presentDrawable:self.currentDrawable];
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];

    [super draw];
}


#pragma mark -- Supporting methods

- (CGRect)alignCenterFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = (CGRectGetWidth(sourceRect) - expectedWidth) / 2.0f;
    CGFloat expectedY = (CGRectGetHeight(sourceRect) - expectedHeight) / 2.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignTopFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = (CGRectGetWidth(sourceRect) - expectedWidth) / 2.0f;
    CGFloat expectedY = CGRectGetHeight(sourceRect) - expectedHeight;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignBottomFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = (CGRectGetWidth(sourceRect) - expectedWidth) / 2.0f;
    CGFloat expectedY = 0.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignLeftFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = 0.0f;
    CGFloat expectedY = (CGRectGetHeight(sourceRect) - expectedHeight) / 2.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignRightFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = CGRectGetWidth(sourceRect) - expectedWidth;
    CGFloat expectedY = (CGRectGetHeight(sourceRect) - expectedHeight) / 2.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignTopLeftFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = 0.0f;
    CGFloat expectedY = CGRectGetHeight(sourceRect) - expectedHeight;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignTopRightFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = CGRectGetWidth(sourceRect) - expectedWidth;
    CGFloat expectedY = CGRectGetHeight(sourceRect) - expectedHeight;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignBottomLeftFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = 0.0f;
    CGFloat expectedY = 0.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignBottomRightFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(targetRect);
    CGFloat expectedHeight = CGRectGetHeight(targetRect);
    CGFloat expectedX = CGRectGetWidth(sourceRect) - expectedWidth;
    CGFloat expectedY = 0.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

@end
