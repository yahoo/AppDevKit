//
//  ControllerTestUtils.h
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/12/9.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ControllerTestUtils : NSObject

+ (void)mockTabBarController;
+ (UINavigationController *)runningNavigationController;

@end
