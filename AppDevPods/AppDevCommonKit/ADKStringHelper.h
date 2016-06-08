//
//  ADKStringHelper.h
//  AppDevKit
//
//  Created by Jeff Lin on 5/21/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>

static const NSTimeInterval s_ADKSecsInMinute = 60.0f;
static const NSTimeInterval s_ADKSecsInHour = 60.0f * s_ADKSecsInMinute;
static const NSTimeInterval s_ADKSecsInDay = 24.0f * s_ADKSecsInHour;

typedef NS_ENUM(NSUInteger, ADKDateCompareStyle) {
    ADKDateCompareStyleShort = 0x0001,                     // 1 unit
    ADKDateCompareStyleMedium = 0x0002,                    // 2 units
    ADKDateCompareStyleLong = 0x0003,                      // 3 units
    ADKDateCompareStyleFull = 0x0004,                      // all units (including seconds)
    ADKDateCompareStyleMask = 0x000F
};

typedef NS_ENUM(NSUInteger, ADKDateCompareOption) {
    ADKDateCompareOptionShowZeroUnit = 0x0010,             // X days 00 hours
    ADKDateCompareOptionShowBeforeAfter = 0x0020,          // XX days (before|after)
    ADKDateCompareOptionAppendZeroPrefix = 0x0040,         // 0X mins
    ADKDateCompareOptionSpaceBetweenUnits = 0x0080         // XdaysYhours v.s. X days Y hours
};

// Date formatter
/**
 *  @brief Getting a fill format time string from a specific date.
 *
 *  @param date Assign the NSDate want to format it.
 *
 *  @return Retuen a full date format string.
 */
NSString *ADKGetFullFormatTimeString(NSDate *date);

/**
 *  @brief Getting a simple format time string from a specific date.
 *
 *  @param date Assign the NSDate want to format it.
 *
 *  @return Retuen a simple date format string.
 */
NSString *ADKGetSimpleFormatTimeString(NSDate *date);

/**
 *  @brief Getting a comparing format time string from a specific date to current time.
 *
 *  @param date Assign the NSDate want to compare it.
 *
 *  @return Return a time distance format string.
 */
NSString *ADKGetDateCompareDescriptionWithDate(NSDate *date);

/**
 *  @brief Getting a full and comparing format time string from a specific date to current time.
 *
 *  @param date Assign the NSDate want to compare it.
 *
 *  @param showBeforeAfter To show before/after string or not.
 *
 *  @return Return a time distance format string.
 */
NSString *ADKGetFullDateCompareDescriptionWithDate(NSDate *date, BOOL showBeforeAfter);

/**
 *  @brief Getting a comparing long format time string from a specific date to current time.
 *
 *  @param date Assign the NSDate want to compare it.
 *  @param style Assign the NSDate want to format it.
 *
 *  @return Return a time distance format string.
 */
NSString *ADKGetStyledDateCompareDescriptionWithDate(NSDate *date, ADKDateCompareStyle style);

// Number formatter
/**
 *  @brief Getting a currency format from giving number.
 *
 *  @param number Assign the NSInteger want to format it.
 *
 *  @return Retuen a currency format string.
 */
NSString *ADKGetThousandSeparatorNumberString(NSInteger number);

// Number formatter
/**
 *  @brief Getting a currency format from giving number with currency symbol.
 *
 *  @param number Assign the NSInteger want to format it.
 *  @param symbol Assign the NSString want to format it.
 *
 *  @return Retuen a currency format string.
 */
NSString *ADKGetCurrencyStringWithCurrencySymbolAndMaximumFractionDigits(NSNumber *number, NSString *currencySymbol, NSInteger maximumFractionDigits);

NSString *ADKFirstNonEmptyString(NSInteger num, ...);

// Directory path
/**
 *  @brief Getting the application Document file path.
 */
NSString *ADKApplicationDocumentsDirectory();

/**
 *  @brief Getting the [application]/library/cache file path.
 *
 *  @return path of cache directory
 */
NSString *ADKApplicationCacheDirectory();
