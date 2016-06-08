//
//  LocationTestUtils.m
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/11/20.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Kiwi/Kiwi.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationTestUtils.h"

@implementation LocationTestUtils

+ (void)setIsLocationServiceAvailable:(BOOL)isEnabled
{
    [CLLocationManager stub:@selector(authorizationStatus) andReturn:theValue(kCLAuthorizationStatusAuthorizedAlways)];
    [CLLocationManager stub:@selector(locationServicesEnabled) andReturn:theValue(isEnabled)];
}

@end
