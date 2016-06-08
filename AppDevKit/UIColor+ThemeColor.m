//
//  UIColor+ThemeColor.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/9/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "UIColor+ThemeColor.h"
#import "AppDevKit.h"

@implementation UIColor (ThemeColor)

+ (UIColor *)themeBackgroundColor
{
    return [UIColor ADKColorWithHexString:@"3D3D3D"];
}

+ (UIColor *)themeCardBackgroundColor
{
    return [UIColor ADKColorWithHexString:@"DDDDDD"];
}

+ (UIColor *)themeBorderColor
{
    return [UIColor ADKColorWithHexString:@"3F3F3F"];
}

+ (UIColor *)themeCellBackgroundColor
{
    return [UIColor ADKColorWithHexString:@"4C4C4C"];
}

+ (UIColor *)themeTitleColor
{
    return [UIColor ADKColorWithHexString:@"FFFFFF"];
}

+ (UIColor *)themeSubtitleColor
{
    return [UIColor ADKColorWithHexString:@"AAAAAA"];
}

+ (UIColor *)themeCellBackgroundSubColor
{
    return [UIColor ADKColorWithHexString:@"EEEEEE"];
}

+ (UIColor *)themeTitleSubColor
{
    return [UIColor ADKColorWithHexString:@"1A1A1A"];
}

+ (UIColor *)themeSubtitleSubColor
{
    return [UIColor ADKColorWithHexString:@"555555"];
}

@end
