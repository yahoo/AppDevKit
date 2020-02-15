//
//  ADKDashedLineViewSpec.m
//  AppDevKitTests
//
//  Created by  Chih Feng Sung on 2/19/19.
//  Copyright © 2019 Yahoo. All rights reserved.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Kiwi.h>
#import "AppDevKit.h"
#import "ImageTestUtils.h"

SPEC_BEGIN(ADKDashedLineViewSpec)

describe(@"Test ADKDashedLineView", ^{
    it(@"should be the expected dash view", ^{
        ADKDashedLineView *dashedLineView = [[ADKDashedLineView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 10.0f)];
        UIGraphicsBeginImageContext(dashedLineView.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [dashedLineView.layer renderInContext:context];
        UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-dashed-line-view-expected.png"];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
    });
});

SPEC_END
