//
//  ADKStringHelperSpec.m
//  AppDevKit
//
//  Created by Wei-Hon (Plasma) Chen on 6/10/14.
//  Copyright © 2016 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Kiwi/Kiwi.h>
#import "ADKStringHelper.h"
#import "ADKCalculatorHelper.h"
#import "TimeTestUtils.h"

SPEC_BEGIN(YDAppUtilSpec)

// The date is Tue Jun 10 16:04:32 CST 2014

static NSInteger testTimeStamp = 1402387472;
describe(@"test ADKGetFullFormatTimeString:NSDate*", ^{
    
    beforeEach(^{
        [TimeTestUtils setTaipeiTimezone];
    });
    
    it(@"with testTimeStamp", ^{
        NSString *dateString = ADKGetFullFormatTimeString([NSDate dateWithTimeIntervalSince1970:testTimeStamp]);
        [[dateString should] equal:@"2014/06/10 16:04"];
    });
});

describe(@"test ADKGetSimpleFormatTimeString:NSDate*", ^{
    
    beforeEach(^{
        [TimeTestUtils setTaipeiTimezone];
    });
    
    it(@"with 2014/Jun/10 ", ^{
        NSString *dateString = ADKGetSimpleFormatTimeString([NSDate dateWithTimeIntervalSince1970:testTimeStamp]);
        [[dateString should] equal:@"2014/06/10"];
    });
});

describe(@"test ADKGetThousandSeparatorNumberString", ^{
    it(@"with 1234", ^{
        NSString *numString = ADKGetThousandSeparatorNumberString(1234);
        [[numString should] equal:@"1,234"];
    });
});

describe(@"test ADKRandomFloatnumber",^{
    it(@"with two float numbers",^{
        [[@(ADKRandomFloatNumber(60.0f, 0.0f)) should] beBetween:@(0.0f) and:@(60.0f)];
    });
});

describe(@"test ADKFirstNonEmptyString(NSArray *)", ^{
    it(@"with two strings", ^{
        NSString *result = ADKFirstNonEmptyString(2, @"hi", @"there");
        [[result should] equal:@"hi"];
    });
    
    it(@"with one empty string, one nil, and one string", ^{
        NSString *result = ADKFirstNonEmptyString(3, @"", nil, @"value");
        [[result should] equal:@"value"];
    });
    
    it(@"with 2 strings and 1 nil in the middle", ^{
        NSString *result = ADKFirstNonEmptyString(3, @"skip", nil, @"value");
        [[result should] equal:@"skip"];
    });
    
    it(@"with nil and one string", ^{
        NSString *result = ADKFirstNonEmptyString(2, nil, @"there");
        [[result should] equal:@"there"];
    });
    
    it(@"with two nils", ^{
        NSString *result = ADKFirstNonEmptyString(2, nil, nil);
        [[result should] equal:@""];
    });
});

describe(@"test ADKGetDateCompareDescriptionWithDate", ^{
    beforeEach(^{
        [TimeTestUtils setTaipeiTimezone];
        [[NSUserDefaults standardUserDefaults] setObject:@[@"zh-Hant"] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
    it(@"with time interval since now is 130 seconds", ^{
        NSString *expected = @"2 分鐘後";
        NSString *compareDateString = ADKGetDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:130]);
        [[compareDateString should] equal:expected];
    });
    
    it(@"with time interval since now is -130 seconds", ^{
        NSString *expected = @"2 分鐘前";
        NSString *compareDateString = ADKGetDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:-130]);
        [[compareDateString should] equal:expected];
    });
    
    it(@"with time interval since now is 3800 seconds", ^{
        NSString *expected = @"1 小時後";
        NSString *compareDateString = ADKGetDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:3800]);
        [[compareDateString should] equal:expected];
    });
    
    it(@"with time interval since now is -10900 seconds", ^{
        NSString *expected = @"3 小時前";
        NSString *compareDateString = ADKGetDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:-10900]);
        [[compareDateString should] equal:expected];
    });
    
    it(@"with time interval since now is 345700 seconds", ^{
        NSString *expected = @"4 天後";
        NSString *compareDateString = ADKGetDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:345700]);
        [[compareDateString should] equal:expected];
    });
    
    it(@"with time interval since now is -86500 seconds", ^{
        NSString *expected = @"1 天前";
        NSString *compareDateString = ADKGetDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:-86500]);
        [[compareDateString should] equal:expected];
        
    });
    
    // 2014-05-22 21:38:18 +0000
    it(@"with time stamp 1400794698 seconds", ^{
        NSString *expected = @"05/23";
        NSString *compareDateString = ADKGetDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSince1970:1400794698]);
        [[compareDateString should] equal:expected];
    });
});

describe(@"test ADKGetStyledDateCompareDescriptionWithDate", ^{
    it(@"test ADKDateCompareStyleShort", ^{
        NSString *expected = @"1天";
        NSString *compareDateString = ADKGetStyledDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:86510], ADKDateCompareStyleShort);
        [[compareDateString should] equal:expected];
        NSLog(@"%@",compareDateString);
    });
    
    it(@"test ADKDateCompareStyleMedium", ^{
        NSString *expected = @"1天1分";
        NSString *compareDateString = ADKGetStyledDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:86510], ADKDateCompareStyleMedium);
        [[compareDateString should] equal:expected];
        NSLog(@"%@",compareDateString);
    });
    
    it(@"test ADKDateCompareStyleLong", ^{
        NSString *expected = @"1天1分";
        NSString *compareDateString = ADKGetStyledDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:86510], ADKDateCompareStyleLong);
        [[compareDateString should] equal:expected];
        NSLog(@"%@",compareDateString);
    });
    
    it(@"test ADKDateCompareStyleFull", ^{
        NSString *expected = @"1天1分49秒";
        NSString *compareDateString = ADKGetStyledDateCompareDescriptionWithDate([NSDate dateWithTimeIntervalSinceNow:86510], ADKDateCompareStyleFull);
        [[compareDateString should] equal:expected];
        NSLog(@"%@",compareDateString);
    });
});

SPEC_END