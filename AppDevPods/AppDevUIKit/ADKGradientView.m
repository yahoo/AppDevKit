//
//  ADKGradientView.m
//  AppDevKit
//
//  Created by Bram Yeh on 12/4/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKGradientView.h"

@implementation ADKGradientView

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

    //reference: http://myappglog.blogspot.tw/2013/07/blog-post.html and http://www.cnblogs.com/zenny-chen/archive/2012/02/23/2364152.html
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)[self.beginColor CGColor], (id)[self.endColor CGColor], nil];
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, (CFArrayRef)gradientColors, nil);
    
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
