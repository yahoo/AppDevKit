//
//  ThemeManager.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/10/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ThemeManager.h"
#import "UIColor+ThemeColor.h"

static ThemeColorMode themeMode;

@interface ThemeManager ()

@end

@implementation ThemeManager

+ (void)setThemeMode:(ThemeColorMode)mode
{
    themeMode = mode;
}

+ (UIColor *)themeCellBackgroundColor
{
    if (themeMode == ThemeColorMain) {
        return [UIColor themeCellBackgroundColor];
    } else {
        return [UIColor themeCellBackgroundSubColor];
    }
}

+ (UIColor *)themeTitleColor
{
    if (themeMode == ThemeColorMain) {
        return [UIColor themeTitleColor];
    } else {
        return [UIColor themeTitleSubColor];
    }
}

+ (UIColor *)themeSubtitleColor
{
    if (themeMode == ThemeColorMain) {
        return [UIColor themeSubtitleColor];
    } else {
        return [UIColor themeSubtitleSubColor];
    }
}

@end
