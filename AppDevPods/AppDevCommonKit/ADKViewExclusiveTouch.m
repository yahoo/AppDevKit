//
//  ADKViewExclusiveTouch.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 10/8/14.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "ADKViewExclusiveTouch.h"

@implementation ADKViewExclusiveTouch

+ (instancetype)sharedInstance
{
    static ADKViewExclusiveTouch *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[ADKViewExclusiveTouch alloc] init];
        }
    });

    return instance;
}

- (BOOL)exclusiveTouchinView:(id)targetView
{
    if ([targetView isKindOfClass:[UIView class]]) {
        UIView *parentView = (UIView *)targetView;
        parentView.exclusiveTouch = YES;
        for (UIView *view in parentView.subviews) {
            view.exclusiveTouch = YES;
        }
    } else {
        return NO;
    }

    return YES;
}

@end
