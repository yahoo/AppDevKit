//
//  TestDynamicCustomCalculationNibFile.m
//  AppDevKit
//
//  Created by Kenny Chu on 2016/4/22.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "TestUncachedCustomCalculationNibFile.h"

static int style = 0;

@implementation TestUncachedCustomCalculationNibFile

#pragma mark - ADKNibSizeCustomCalculationProtocol

- (CGSize)sizeThatFitsWidth:(CGFloat)width
{
    CGFloat height = 130.0f;

    if (style % 2 == 1) {
        height = 140.0f;
    }

    style++;

    return CGSizeMake(width, height);
}

@end
