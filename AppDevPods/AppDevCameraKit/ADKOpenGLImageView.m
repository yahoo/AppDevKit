//
//  ADKOpenGLImageView.m
//  AppDevKit
//
//  Created by  Chih Feng Sung on 9/11/17.
//  Copyright © 2017, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.

#import "ADKOpenGLImageView.h"

@interface ADKOpenGLImageView()

@property (strong, nonatomic) CIContext *ciContext;

@end

@implementation ADKOpenGLImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        self.ciContext = [CIContext contextWithEAGLContext:eaglContext
                                                   options:@{kCIContextWorkingColorSpace:[NSNull null]}];
        self.context = eaglContext;
        [EAGLContext setCurrentContext:eaglContext];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        self.ciContext = [CIContext contextWithEAGLContext:eaglContext
                                                   options:@{kCIContextWorkingColorSpace:[NSNull null]}];
        self.context = eaglContext;
        [EAGLContext setCurrentContext:eaglContext];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self drawBackground];
    [self drawImage];
}


#pragma mark -- Setter and Getter methods

- (void)setImage:(CIImage *)image
{
    _image = image;

    [self drawBackground];
    [self drawImage];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];

    [self drawBackground];
}

- (UIColor *)backgroundColor
{
    UIColor *backgroundColor = [super backgroundColor];

    if (backgroundColor) {
        return backgroundColor;
    } else {
        return [UIColor clearColor];
    }
}


#pragma mark -- Private methods

- (void)drawBackground
{
    CGFloat redColor;
    CGFloat greenColor;
    CGFloat blueColor;
    CGFloat alphaColor;
    [self.backgroundColor getRed:&redColor green:&greenColor blue:&blueColor alpha:&alphaColor];

    glClearColor(redColor, greenColor, blueColor, alphaColor);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)drawImage
{
    CGRect drawRect;
    CGRect drawableRect;

    [self bindDrawable];

    drawableRect = CGRectMake(0.0f, 0.0f, self.drawableWidth, self.drawableHeight);
    switch (self.contentMode) {
        case ADKOpenGLImageViewContentModeScaleAspectFit:
            drawRect = [self scaleAspectFitFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeScaleAspectFill:
            drawRect = [self scaleAspectFillFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeCenter:
            drawRect = [self alignCenterFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeTop:
            drawRect = [self alignTopFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeBottom:
            drawRect = [self alignBottomFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeLeft:
            drawRect = [self alignLeftFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeRight:
            drawRect = [self alignRightFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeTopLeft:
            drawRect = [self alignTopLeftFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeTopRight:
            drawRect = [self alignTopRightFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeBottomLeft:
            drawRect = [self alignBottomLeftFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeBottomRight:
            drawRect = [self alignBottomRightFromRect:self.image.extent toRect:drawableRect];
            break;
        case ADKOpenGLImageViewContentModeScaleToFill:
        default:
            drawRect = CGRectMake(0.0f, 0.0f, self.drawableWidth, self.drawableHeight);
            break;
    }

    [self.ciContext drawImage:self.image inRect:drawRect fromRect:self.image.extent];

    [self display];
}


#pragma mark -- Supporting methods

- (CGRect)scaleAspectFitFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGRect expectedRect;
    
    CGFloat scale = CGRectGetWidth(targetRect) / CGRectGetWidth(sourceRect);
    if (CGRectGetHeight(sourceRect) * scale >= CGRectGetHeight(targetRect)) {
        scale = CGRectGetHeight(targetRect) / CGRectGetHeight(sourceRect);
    }

    CGRect scaledRect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(sourceRect) * scale, CGRectGetHeight(sourceRect) * scale);
    expectedRect = [self alignCenterFromRect:scaledRect toRect:targetRect];

    return expectedRect;
}

- (CGRect)scaleAspectFillFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGRect expectedRect;

    CGFloat scale = CGRectGetWidth(targetRect) / CGRectGetWidth(sourceRect);
    if (CGRectGetHeight(sourceRect) * scale <= CGRectGetHeight(targetRect)) {
        scale = CGRectGetHeight(targetRect) / CGRectGetHeight(sourceRect);
    }

    CGRect scaledRect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(sourceRect) * scale, CGRectGetHeight(sourceRect) * scale);
    expectedRect = [self alignCenterFromRect:scaledRect toRect:targetRect];

    return expectedRect;
}

- (CGRect)alignCenterFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = (CGRectGetWidth(targetRect) - expectedWidth) / 2.0f;
    CGFloat expectedY = (CGRectGetHeight(targetRect) - expectedHeight) / 2.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignTopFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = (CGRectGetWidth(targetRect) - expectedWidth) / 2.0f;
    CGFloat expectedY = CGRectGetHeight(targetRect) - expectedHeight;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignBottomFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = (CGRectGetWidth(targetRect) - expectedWidth) / 2.0f;
    CGFloat expectedY = 0.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignLeftFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = 0.0f;
    CGFloat expectedY = (CGRectGetHeight(targetRect) - expectedHeight) / 2.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignRightFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = CGRectGetWidth(targetRect) - expectedWidth;
    CGFloat expectedY = (CGRectGetHeight(targetRect) - expectedHeight) / 2.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignTopLeftFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = 0.0f;
    CGFloat expectedY = CGRectGetHeight(targetRect) - expectedHeight;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignTopRightFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = CGRectGetWidth(targetRect) - expectedWidth;
    CGFloat expectedY = CGRectGetHeight(targetRect) - expectedHeight;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignBottomLeftFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = 0.0f;
    CGFloat expectedY = 0.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}

- (CGRect)alignBottomRightFromRect:(CGRect)sourceRect toRect:(CGRect)targetRect
{
    CGFloat expectedWidth = CGRectGetWidth(sourceRect);
    CGFloat expectedHeight = CGRectGetHeight(sourceRect);
    CGFloat expectedX = CGRectGetWidth(targetRect) - expectedWidth;
    CGFloat expectedY = 0.0f;

    return CGRectMake(expectedX, expectedY, expectedWidth, expectedHeight);
}


@end
