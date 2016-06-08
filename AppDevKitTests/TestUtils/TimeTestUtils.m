//
//  TimeTestUtils.m
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/11/20.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Kiwi/Kiwi.h>
#import "TimeTestUtils.h"

@implementation TimeTestUtils

+ (void)setTaipeiTimezone
{
    // Time zone of Asia/Taipei is GMT+8
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:(8 * 60 * 60)];
    NSDateFormatter *taipeiDateFormatter = [[NSDateFormatter alloc] init];
    [taipeiDateFormatter setTimeZone:timeZone];
    [NSDateFormatter stub:@selector(alloc) andReturn:taipeiDateFormatter];
    [taipeiDateFormatter stub:@selector(init) andReturn:taipeiDateFormatter];
}

+ (void)mockTimeIntervalSinceNow:(NSString*)timeStampText
{
    // It is weird that sometimes __NSTaggedDate object is returned, and Kiwi cannot stub methods into it.
    // Our solution is just retry it for 50 times.
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    int i = 0;
    while (![NSStringFromClass([date class]) isEqual:@"__NSDate"] && i < 50) {
        date = [NSDate dateWithTimeIntervalSinceNow:1];
        i++;
    }
    [date stub:@selector(timeIntervalSinceNow) andReturn:theValue([timeStampText doubleValue])];
    [NSDate stub:@selector(dateWithTimeIntervalSince1970:) andReturn:date];
}

+ (void)mockTimeIntervalSince1970:(NSString*)timeStampText
{
    // It is weird that sometimes __NSTaggedDate object is returned, and Kiwi cannot stub methods into it.
    // Our solution is just retry it for 50 times.
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    int i = 0;
    while (![NSStringFromClass([date class]) isEqual:@"__NSDate"] && i < 50) {
        date = [NSDate dateWithTimeIntervalSinceNow:1];
        i++;
    }
    [date stub:@selector(timeIntervalSince1970) andReturn:theValue([timeStampText doubleValue])];
    [NSDate stub:@selector(date) andReturn:date];
}

@end
