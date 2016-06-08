//
//  ADKAppUtil.h
//  AppDevKit
//
//  Created by Jeff Lin on 5/21/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @brief Check device's screen is a logner screen. For example: iPhone 6, 5s, 6, 6+ and etc.
 *
 *  @return YES if screen is longer than iPhone 4 / 4s and iPad.
 */
BOOL ADKIsLongerScreen();

/**
 *  @brief Check device's OS version is below iOS 7.
 *
 *  @return YES if OS verion is below 7.
 */
BOOL ADKIsBelowIOS7();

/**
 *  @brief Check device's OS version is below iOS 8.
 *
 *  @return YES if OS verion is below 8.
 */
BOOL ADKIsBelowIOS8();

/**
 *  @brief Check device's OS version is below iOS 9.
 *
 *  @return YES if OS verion is below 9.
 */
BOOL ADKIsBelowIOS9();

/**
 *  @brief Check whether location services available. This is an expensive call. It should not be called frequently or from performance sensitive code.
 *
 *  @return YES if location services enabled and authorized, NO otherwise.
 */
BOOL ADKIsLocationServicesAvailableOrNotDetermined();


/**
 *  @brief Return a screen scaling ratio, use a particular nib size as reference (Alway in portrait orientation)
 *
 *  @return CGFloat
 */
CGFloat ADKPortraitScreenRatio();

/**
 *  @brief Return a screen size (Alway in portrait orientation)
 *
 *  @return CGSize
 */
CGSize ADKPortraitScreenSize();

/**
 *  @brief Return a screen bound (Alway in portrait orientation)
 *
 *  @return CGRect
 */
CGRect ADKPortraitScreenBoundRect();
