//
//  TestNibFile.m
//  AppDevKit
//
//  Created by Kenny Chu on 2016/4/18.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "TestNibFile.h"

@implementation TestNibFile

#pragma mark - ADKNibSizeCustomCalculationProtocol

- (CGSize)sizeThatFitsWidth:(CGFloat)width
{
    CGFloat height = 130.0f;

    return CGSizeMake(width, height);
}

@end
