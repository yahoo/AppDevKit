//
//  ViewTestUtil.m
//  AppDevKit
//
//  Created by Jeff Lin on 10/2/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

#import "ViewTestUtil.h"

@implementation ViewTestUtil

+ (void)stubMainScreenBoundsWithRect:(CGRect)rect
{
    // stub bounds
    [[UIScreen mainScreen] stub:@selector(bounds) andReturn:theValue(rect)];
    // stub fixedCoordinateSpace
    id coordinateSpaceMock = [KWMock mockForProtocol:@protocol(UICoordinateSpace)];
    [coordinateSpaceMock stub:@selector(bounds) andReturn:theValue(rect)];
    [[UIScreen mainScreen] stub:@selector(fixedCoordinateSpace) andReturn:theValue(coordinateSpaceMock)];
}

@end
