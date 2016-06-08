//
//  UIView+ADKGetUIViewController.m
//  AppDevKit
//
//  Created by Bram Yeh on 10/28/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "UIView+ADKGetUIViewController.h"

@implementation UIView (ADKGetUIViewController)

- (UIViewController *)ADKParentViewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }
    else if ([nextResponder isKindOfClass:[UIView class]]) {
        return ((UIView *)nextResponder).ADKParentViewController;
    }
    
    return nil;
}

@end
