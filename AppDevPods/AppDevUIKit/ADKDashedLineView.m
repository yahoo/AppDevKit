//
//  ADKDashedLineView.m
//  AppDevKit
//
//  Created by Bram Yeh on 10/7/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKDashedLineView.h"

@implementation ADKDashedLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(contextRef, 2.0f);
    
    // Dashed Line Patterns
    CGFloat lengths[] = {5.0f, 5.0f};
    CGContextSetLineDash(contextRef, 0.0f, lengths, 2);
    
    CGContextBeginPath(contextRef);
    
    CGFloat halfWayUp = (rect.size.height - 1.0f) / 2.0f + rect.origin.y;
    CGContextMoveToPoint(contextRef, rect.origin.x + 2.0f, halfWayUp);
    CGContextAddLineToPoint(contextRef, rect.origin.x + rect.size.width, halfWayUp);
    CGContextStrokePath(contextRef);
}

@end
