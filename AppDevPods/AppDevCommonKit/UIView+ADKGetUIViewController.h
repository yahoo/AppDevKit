//
//  UIView+ADKGetUIViewController.h
//  AppDevKit
//
//  Created by Bram Yeh on 10/28/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

@interface UIView (ADKGetUIViewController)

/**
 * @brief Support get specific UIView's parent UIViewController.
 */
@property (nonatomic, readonly) UIViewController *ADKParentViewController;

@end
