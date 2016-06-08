//
//  UIView+ADKAnimationMacro.m
//  AppDevKit
//
//  Created by Jeff Lin on 6/3/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "UIView+ADKAnimationMacro.h"

@implementation UIView (ADKAnimationMacro)
- (void)popUpAnimation{
    self.alpha = 1.0f;

    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounce.values = [NSArray arrayWithObjects:
                    [NSNumber numberWithFloat:0.5f],
                    [NSNumber numberWithFloat:1.1f],
                    [NSNumber numberWithFloat:0.8f],
                    [NSNumber numberWithFloat:1.0f], nil];
    bounce.duration = 0.4f;
    bounce.removedOnCompletion = NO;
    [self.layer addAnimation:bounce forKey:@"bounce"];
}

@end
