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
    self = [super initWithCoder:coder];
    if (self) {
        self.blendsType = ADKBlendsTypeFromTopToBottom;
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView
{
    // reset original background color
    self.backgroundColor = [UIColor clearColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    //reference: http://myappglog.blogspot.tw/2013/07/blog-post.html and http://www.cnblogs.com/zenny-chen/archive/2012/02/23/2364152.html
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)[self.beginColor CGColor], (id)[self.endColor CGColor], nil];
    CGFloat gradientLocation[] = {0.0f, 1.0f};
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, (CFArrayRef)gradientColors, gradientLocation);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
    CGContextSaveGState(contextRef);
    [bezierPath addClip];
    [bezierPath setLineWidth:0.0f];
    
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
    [bezierPath stroke];
    
    CGContextRestoreGState(contextRef);
    
    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradientRef);
}

@end
