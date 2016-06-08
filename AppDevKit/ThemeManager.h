//
//  ThemeManager.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/10/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ThemeColorMode) {
    ThemeColorMain = 0,
    ThemeColorSub,
};

@interface ThemeManager : NSObject

+ (void)setThemeMode:(ThemeColorMode)mode;

+ (UIColor *)themeCellBackgroundColor;
+ (UIColor *)themeTitleColor;
+ (UIColor *)themeSubtitleColor;

@end
