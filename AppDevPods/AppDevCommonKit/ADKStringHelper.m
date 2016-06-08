//
//  ADKStringHelper.m
//  AppDevKit
//
//  Created by Jeff Lin on 5/21/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKStringHelper.h"

static NSDateFormatter *s_cachedDateFormatter;
static NSNumberFormatter *s_cachedNumberFormatter;

NSDateFormatter *cachedDateFormatter()
{
    @synchronized(s_cachedDateFormatter) {
        if (!s_cachedDateFormatter) {
            s_cachedDateFormatter = [[NSDateFormatter alloc] init];
        }
    }

    return s_cachedDateFormatter;
}

NSNumberFormatter *cachedNumberFormatter()
{
    @synchronized(s_cachedNumberFormatter) {
        if (!s_cachedNumberFormatter) {
            s_cachedNumberFormatter = [[NSNumberFormatter alloc] init];
        }
    }

    return s_cachedNumberFormatter;
}

#pragma mark - date
NSString *ADKGetFullFormatTimeString(NSDate *date)
{
    NSDateFormatter *dateFormatter = cachedDateFormatter();
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    
    return str;
}

NSString *ADKGetSimpleFormatTimeString(NSDate *date)
{
    NSDateFormatter *dateFormatter = cachedDateFormatter();
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    
    return str;
}

NSString *ADKGetDateCompareDescriptionWithDate(NSDate *date)
{
    BOOL isBeforeNow = NO;
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (timeInterval <= 0.0f) {
        timeInterval *= -1.0f;
        isBeforeNow = YES;
    }

    NSString *str = @"";

    if ((timeInterval / s_ADKSecsInMinute) < 60.0f) {
        NSUInteger min = (NSUInteger)(timeInterval / s_ADKSecsInMinute);
        str = [NSString stringWithFormat:@"%lu 分鐘%@", (unsigned long)min, (isBeforeNow ? @"前" : @"後")]; //TRANSLATE
    }
    else if ((timeInterval / s_ADKSecsInHour) < 24.0f) {
        NSUInteger hour = (NSUInteger)(timeInterval / s_ADKSecsInHour);
        str = [NSString stringWithFormat:@"%lu 小時%@", (unsigned long)hour, (isBeforeNow ? @"前" : @"後")]; //TRANSLATE
    }
    else if ((timeInterval / s_ADKSecsInDay) <= 30.0f) {
        NSUInteger day = (NSUInteger)(timeInterval / s_ADKSecsInDay);
        str = [NSString stringWithFormat:@"%lu 天%@", (unsigned long)day, (isBeforeNow ? @"前" : @"後")]; //TRANSLATE
    }
    else {
        NSDateFormatter *dateFormatter = cachedDateFormatter();
        [dateFormatter setDateFormat:@"MM/dd"];
        str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }

    return str;
}

NSString *ADKGetFullDateCompareDescriptionWithDate(NSDate *date, BOOL showBeforeAfter)
{
    BOOL isBeforeNow = NO;
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (timeInterval <= 0.0f) {
        timeInterval *= -1.0f;
        isBeforeNow = YES;
    }
    
    NSString *str = @"";
    
    if ((timeInterval / s_ADKSecsInDay) > 0.0f) {
        NSUInteger day = (NSUInteger)(timeInterval / s_ADKSecsInDay);
        if (day > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%lu 天 ", (unsigned long)day]]; //TRANSLATE
            timeInterval -= (day * s_ADKSecsInDay);
        }
    }
    
    if (fmod(timeInterval, s_ADKSecsInDay) && (timeInterval / s_ADKSecsInHour) > 0.0f) {
        NSUInteger hour = (NSUInteger)(timeInterval / s_ADKSecsInHour);
        if (hour > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%lu 小時 ", (unsigned long)hour]]; //TRANSLATE
            timeInterval -= (hour * s_ADKSecsInHour);
        }
    }
    
    if (fmod(timeInterval, s_ADKSecsInHour) && (timeInterval / s_ADKSecsInMinute) > 0.0f) {
        NSUInteger min = (NSUInteger)(timeInterval / s_ADKSecsInMinute);
        if (min > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%lu 分鐘 ", (unsigned long)min]]; //TRANSLATE
        }
    }
    
    if ( ![str isEqual:@""] ) {
        str = [str substringToIndex:(str.length - 1)];
        
        if (showBeforeAfter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", (isBeforeNow ? @"前" : @"後")]]; //TRANSLATE
        }
    }
    
    return str;
}

NSString *ADKGetStyledDateCompareDescriptionWithDate(NSDate *date, ADKDateCompareStyle style)
{
    BOOL showZeroUnit = (style & ADKDateCompareOptionShowZeroUnit);
    BOOL showBeforeAfter = (style & ADKDateCompareOptionShowBeforeAfter);
    BOOL appendZeroPrefix = (style & ADKDateCompareOptionAppendZeroPrefix);
    BOOL spaceBetweenUnits = (style & ADKDateCompareOptionSpaceBetweenUnits);

    BOOL isBeforeNow = NO;
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (timeInterval <= 0.0f) {
        timeInterval *= -1.0f;
        isBeforeNow = YES;
    }

    NSString *strDateDay = @"天";            // TRANSLATE
    NSString *strDateHour = @"小時";          // TRANSLATE
    NSString *strDateMinute = @"分";         // TRANSLATE
    NSString *strDateSecond = @"秒";         // TRANSLATE
    NSString *strDateBefore = @"前";         // TRANSLATE
    NSString *strDateAfter = @"後";          // TRANSLATE

    NSString *unitSpacer = spaceBetweenUnits ? @" " : @"";
    NSString *str = @"";
    NSInteger timeUnits = 0;

    if ((timeInterval / s_ADKSecsInDay) > 0.0f) {
        NSUInteger day = (NSUInteger)(timeInterval / s_ADKSecsInDay);
        if (day > 0) {
            NSString *timeFormatterStr = @"%lu";
            str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) day]];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateDay, unitSpacer]];
            timeInterval -= (day * s_ADKSecsInDay);
            timeUnits++;
        }
    }

    if (timeUnits < (style & ADKDateCompareStyleMask)) {
        if (fmod(timeInterval, s_ADKSecsInDay) && (timeInterval / s_ADKSecsInHour) > 0.0f) {
            NSUInteger hour = (NSUInteger)(timeInterval / s_ADKSecsInHour);
            if (hour > 0 || (timeUnits && showZeroUnit)) {
                NSString *timeFormatterStr = (appendZeroPrefix && timeUnits) ? @"%02lu" : @"%lu";
                str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) hour]];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateHour, unitSpacer]];
                timeUnits++;
            }
            timeInterval -= (hour * s_ADKSecsInHour);
        }
    }

    if (timeUnits < (style & ADKDateCompareStyleMask)) {
        if (fmod(timeInterval, s_ADKSecsInHour) && (timeInterval / s_ADKSecsInMinute) > 0.0f) {
            NSUInteger min = (NSUInteger)(timeInterval / s_ADKSecsInMinute);
            if (min > 0 || (timeUnits && showZeroUnit)) {
                NSString *timeFormatterStr = (appendZeroPrefix && timeUnits) ? @"%02lu" : @"%lu";
                str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) min]];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateMinute, unitSpacer]];
                timeUnits++;
            }
        }
    }

    if (style & ADKDateCompareStyleFull) {
        if (fmod(timeInterval, s_ADKSecsInHour) && (timeInterval / s_ADKSecsInMinute) > 0.0f) {
            NSUInteger sec = (NSUInteger)((int) timeInterval % (int) s_ADKSecsInMinute);
            NSString *timeFormatterStr = (appendZeroPrefix && timeUnits) ? @"%02lu" : @"%lu";
            str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) sec]];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateSecond, unitSpacer]];
        }
    }

    if (str.length > 0) {
        if (unitSpacer.length > 0) {
            str = [str substringToIndex:(str.length - unitSpacer.length)];
        }

        if (showBeforeAfter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", (isBeforeNow ? strDateBefore : strDateAfter)]];
        }
    }
    
    return str;
}

#pragma mark - format
NSString *ADKGetThousandSeparatorNumberString(NSInteger number)
{
    return ADKGetCurrencyStringWithCurrencySymbolAndMaximumFractionDigits([NSNumber numberWithInteger:number], @"", 0);
}

NSString *ADKGetCurrencyStringWithCurrencySymbolAndMaximumFractionDigits(NSNumber *number, NSString *currencySymbol, NSInteger maximumFractionDigits)
{
    NSNumberFormatter *formatter = cachedNumberFormatter();
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    formatter.currencySymbol = currencySymbol;
    formatter.maximumFractionDigits = maximumFractionDigits;

    return [formatter stringFromNumber:number];
}

NSString *ADKFirstNonEmptyString(NSInteger num, ...)
{
    va_list ap;
    NSString *result;
    
    va_start(ap, num);
    for (int i = 0; i < num; i++) {
        NSString *str = va_arg(ap, NSString *);
        if (str && [str isKindOfClass:[NSString class]] && [str length] > 0) {
            result = str;
            break;
        }
    }
    
    return result ? result : @"";
}

#pragma mark - File Path
NSString *ADKApplicationDocumentsDirectory()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths lastObject];
    return basePath;
}

NSString *ADKApplicationCacheDirectory()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths lastObject];
    return basePath;
}
