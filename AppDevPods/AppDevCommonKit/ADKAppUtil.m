//
//  ADKAppUtil.m
//  AppDevKit
//
//  Created by Jeff Lin on 5/21/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKAppUtil.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

BOOL ADKIsLongerScreen()
{
    // iPhone 4 and iPad will idendifer to short screen.
    // the shorter ratio of screen width / height, the longer screen
    return ADKPortraitScreenRatio() < 0.65f;
}

BOOL ADKIsBelowIOS7()
{
    return ![UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)];
}

BOOL ADKIsBelowIOS8()
{
    return ![UIImage instancesRespondToSelector:@selector(imageAsset)];
}

BOOL ADKIsBelowIOS9()
{
    return ![UIImage instancesRespondToSelector:@selector(imageFlippedForRightToLeftLayoutDirection)];
}

BOOL ADKIsLocationServicesAvailableOrNotDetermined()
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return ([CLLocationManager locationServicesEnabled] &&
            (status == kCLAuthorizationStatusAuthorizedAlways ||
             status == kCLAuthorizationStatusAuthorizedWhenInUse ||
             status == kCLAuthorizationStatusNotDetermined));
}


#pragma mark - nibsize and screen ratio calculate

CGFloat ADKPortraitScreenRatio()
{
    CGRect screenRect = ADKPortraitScreenBoundRect();
    CGFloat ratio = CGRectGetWidth(screenRect) / CGRectGetHeight(screenRect);
    return ratio;
}

CGSize ADKPortraitScreenSize()
{
    return ADKPortraitScreenBoundRect().size;
}

CGRect ADKPortraitScreenBoundRect()
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect;
    if ([screen respondsToSelector:@selector(fixedCoordinateSpace)]) {
        screenRect = screen.fixedCoordinateSpace.bounds;
    } else {
        screenRect = screen.bounds;
    }

    return screenRect;
}