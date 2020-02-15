//
//  ADKMultiGradientView.m
//  AppDevKit
//
//  Created by  Chih Feng Sung on 1/29/19.
//  Copyright © 2019 Yahoo. All rights reserved.
//

#import "ADKMultiGradientView.h"

@interface ADKMultiGradientView ()

@end

@implementation ADKMultiGradientView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    self.blendsType = ADKBlendsTypeFromTopToBottom;
}

-(void)redrawView
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();

    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:self.gradientColors.count];
    for (int i = 0; i < self.gradientColors.count; i++) {
        colors[i] =(id)[(UIColor *)[self.gradientColors objectAtIndex:i] CGColor];
    }

    CGFloat locations[self.gradientLocations.count];
    for (int i = 0; i < self.gradientLocations.count; i++) {
        locations[i] = [(NSNumber *)[self.gradientLocations objectAtIndex:i] floatValue];
    }

    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, (CFArrayRef)colors, locations);

    CGPoint beginPoint;
    CGPoint endPoint;
    switch (self.blendsType) {
        case ADKBlendsTypeFromLeftToRight:
            beginPoint = CGPointMake(0.0f, CGRectGetHeight(rect) / 2.0f);
            endPoint = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2.0f);
            break;
        case ADKBlendsTypeFromLeftTopToRightBottom:
            beginPoint = CGPointMake(0.0f, 0.0f);
            endPoint = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
            break;
        case ADKBlendsTypeFromRightTopToLeftBottom:
            beginPoint = CGPointMake(CGRectGetWidth(rect), 0.0f);
            endPoint = CGPointMake(0.0f, CGRectGetHeight(rect));
            break;
        case ADKBlendsTypeFromTopToBottom:
        default:
            beginPoint = CGPointMake(CGRectGetWidth(rect) / 2.0f, 0.0f);
            endPoint = CGPointMake(CGRectGetWidth(rect) / 2.0f, CGRectGetHeight(rect));
    }

    CGContextDrawLinearGradient(contextRef, gradientRef, beginPoint, endPoint, 0);

    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradientRef);
}

@end
