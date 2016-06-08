//
//  ADKNibSizeCalculatroSpec.m
//  AppDevKit
//
//  Created by Qing-Cheng Li on 11/10/14.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Kiwi/Kiwi.h>
#import "ADKAppUtil.h"
#import "ADKNibSizeCalculator.h"

SPEC_BEGIN(ADKNibSizeCalculatorSpec)

static NSString * const kTestNibName = @"TestNibFile";
static NSString * const kSpecialSizeNibName = @"SpecialSizeNibFile";
static double const kPrecision = 0.00001f;

describe(@"test sharedInstance", ^{
    it(@"should be the same",^{
        ADKNibSizeCalculator *expected = [ADKNibSizeCalculator sharedInstance];
        [[expected shouldNot] beNil];
        [[theValue([ADKNibSizeCalculator sharedInstance] == expected) should] beTrue];
    });
});

describe(@"test sizeForNibNamed:nibName", ^{
    let(calculator, ^id{
        return [ADKNibSizeCalculator sharedInstance];
    });

    beforeEach(^{
        CGRect const stubScreenSize = CGRectMake(0.0f, 0.0f, 375.0f, 568.0f);
        [[UIScreen mainScreen] stub:@selector(bounds) andReturn:theValue(stubScreenSize)];
        // let calculator use the bundle which contains test nib files
        [NSBundle stub:@selector(mainBundle) andReturn:[NSBundle bundleForClass:[self class]]];
    });

    it(@"for size of CategoryStartPageCell",^{
        CGSize expected = CGSizeMake(375.0f, 146.484375f);
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });
});

describe(@"test sizeForNibNamed:nibName withStyle:style", ^{
    let(calculator, ^id{
        return [ADKNibSizeCalculator sharedInstance];
    });

    beforeEach(^{
        CGRect const stubScreenSize = CGRectMake(0.0f, 0.0f, 375.0f, 568.0f);
        [[UIScreen mainScreen] stub:@selector(bounds) andReturn:theValue(stubScreenSize)];
        [NSBundle stub:@selector(mainBundle) andReturn:[NSBundle bundleForClass:[self class]]];
    });
    
    it(@"for style ADKFixedHeight",^{
        CGSize expected = CGSizeMake(375.0f, 125.0f);
        ADKNibSizeStyle style = ADKNibFixedHeightScaling;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(nibSize.width - expected.width) should] beLessThan:theValue(kPrecision)];
        [[@(nibSize.height - expected.height) should] beLessThan:theValue(kPrecision)];
    });
    
    it(@"for style ADKNibDefaultScaling",^{
        CGSize expected = CGSizeMake(375.0f, 146.484375f);
        ADKNibSizeStyle style = ADKNibDefaultScaling;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });
    
    it(@"for style ADKNibOriginalSize",^{
        CGSize expected = CGSizeMake(320.0f, 125.0f);
        ADKNibSizeStyle style = ADKNibOriginalSize;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });
    
    it(@"for style ADKNibBottomFixedScaling",^{
        CGSize expected = CGSizeMake(375.0f, 180.0f);
        ADKNibSizeStyle style = ADKNibBottomFixedScaling;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });

    it(@"for style ADKNibCustomCalculation", ^{
        CGSize expected = CGSizeMake(375.0f, 130.0f);
        ADKNibSizeStyle style = ADKNibCustomCalculation;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });

    it(@"for style ADKNibCustomCalculation with a nib file that doesn't conform to ADKNibSizeCustomCalculationProtocol", ^{
        // Use ADKNibDefaultScaling when it doesn't conform to ADKNibSizeCustomCalculationProtocol
        CGSize expected = CGSizeMake(375.0f, 294.0f);
        ADKNibSizeStyle style = ADKNibCustomCalculation;
        CGSize nibSize = [calculator sizeForNibNamed:kSpecialSizeNibName withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });

    it(@"for style ADKNibUncachedCustomCalculation", ^{
        CGSize expected = CGSizeMake(375.0f, 130.0f);
        ADKNibSizeStyle style = ADKNibUncachedCustomCalculation;
        CGSize nibSize = [calculator sizeForNibNamed:@"TestUncachedCustomCalculationNibFile" withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
        expected = CGSizeMake(375.0f, 140.0f);
        nibSize = [calculator sizeForNibNamed:@"TestUncachedCustomCalculationNibFile" withStyle:style];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(ADKPortraitScreenSize().width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });
});

describe(@"test sizeForNibNamed:nibName withStyle:style fitSize:containerSize", ^{
    let(calculator, ^id{
        return [ADKNibSizeCalculator sharedInstance];
    });

    beforeEach(^{
        CGRect const stubScreenSize = CGRectMake(0.0f, 0.0f, 414.0f, 736.0f);
        [[UIScreen mainScreen] stub:@selector(bounds) andReturn:theValue(stubScreenSize)];
        [NSBundle stub:@selector(mainBundle) andReturn:[NSBundle bundleForClass:[self class]]];
    });

    it(@"for style ADKFixedHeight with a container's width smaller than screen's",^{
        CGSize containerSize = CGSizeMake(345.0f, 200.0f);
        CGSize expected = CGSizeMake(345.0f, 125.0f);
        ADKNibSizeStyle style = ADKNibFixedHeightScaling;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style fitSize:containerSize];
        [[theValue(containerSize.width) should] beLessThan:theValue(ADKPortraitScreenSize().width)];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(containerSize.width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });

    it(@"for style ADKNibDefaultScaling with a container's height smaller than original's",^{
        CGSize containerSize = CGSizeMake(414.0f, 100.0f);
        CGSize originalSize = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibOriginalSize];
        CGSize expected = CGSizeMake(414.0f, 100.0f);
        ADKNibSizeStyle style = ADKNibDefaultScaling;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style fitSize:containerSize];
        [[theValue(containerSize.height) should] beLessThan:theValue(originalSize.height)];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(containerSize.width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });

    it(@"for style ADKNibOriginalSize with a container smaller than original",^{
        CGSize containerSize = CGSizeMake(300.0f, 100.0f);
        CGSize originalSize = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibOriginalSize];
        CGSize expected = CGSizeMake(300.0f, 100.0f);
        ADKNibSizeStyle style = ADKNibOriginalSize;
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:style fitSize:containerSize];
        [[theValue(containerSize.width) should] beLessThan:theValue(originalSize.width)];
        [[theValue(containerSize.height) should] beLessThan:theValue(originalSize.height)];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(containerSize.width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });

    it(@"for style ADKNibBottomFixedScaling with a special size nib file",^{
        // This speical size nib file's ratio may cause floating calculation issue,
        // the calculated width may greater than container's width.
        // For example, this special size nib file's size is (375, 294), container's width is 414,
        // the expected width is ratio (container's width / original width) * original width,
        // which is (414 / 375) * 375 = 414, but the calculated width is 414.00000000000005684342.
        // So, this test case also want to make sure the calculator will not return a width greater
        // than container's width.
        CGSize containerSize = CGSizeMake(414.0f, 10.0f);
        CGSize expected = CGSizeMake(414.0f, 10.0f);
        ADKNibSizeStyle style = ADKNibBottomFixedScaling;
        CGSize nibSize = [calculator sizeForNibNamed:kSpecialSizeNibName withStyle:style fitSize:containerSize];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(containerSize.width)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
    });
});

describe(@"test ADKNibSizeCalculator cache", ^{
    let(calculator, ^id{
        // return a new instance with independent cache space
        return [[ADKNibSizeCalculator alloc] init];
    });

    beforeEach(^{
        CGRect const stubScreenSize = CGRectMake(0.0f, 0.0f, 375.0f, 568.0f);
        [[UIScreen mainScreen] stub:@selector(bounds) andReturn:theValue(stubScreenSize)];
        [NSBundle stub:@selector(mainBundle) andReturn:[NSBundle bundleForClass:[self class]]];
    });

    it(@"use the same style should get the smae result", ^{
        CGSize expected = CGSizeMake(375.0f, 146.484375f);
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibDefaultScaling];
        CGSize askAgainSize = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibDefaultScaling];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
        [[theValue(askAgainSize.width) should] equal:theValue(nibSize.width)];
        [[theValue(askAgainSize.height) should] equal:theValue(nibSize.height)];
    });

    it(@"use different style should get different result", ^{
        CGSize expected = CGSizeMake(375.0f, 146.484375f);
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibDefaultScaling];
        CGSize askAgainSizeWithDifferentStyle = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibOriginalSize];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
        [[theValue(askAgainSizeWithDifferentStyle.width) shouldNot] equal:theValue(nibSize.width)];
    });

    it(@"use the same style but different containerSize should get different result", ^{
        CGSize containerSize = CGSizeMake(375.0f, 100.0f);
        CGSize expected = CGSizeMake(375.0f, 100.0f);
        CGSize anotherContainerSize = CGSizeMake(140.0f, 20.0f);
        CGSize anotherExpectedSize = CGSizeMake(140.0f, 20.0f);
        CGSize nibSize = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibDefaultScaling fitSize:containerSize];
        CGSize askAgainSizeWithDifferentContainer = [calculator sizeForNibNamed:kTestNibName withStyle:ADKNibDefaultScaling fitSize:anotherContainerSize];
        [[theValue(nibSize.width) shouldNot] beGreaterThan:theValue(containerSize.width)];
        [[theValue(nibSize.height) shouldNot] beGreaterThan:theValue(containerSize.height)];
        [[@(fabs(nibSize.width - expected.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(nibSize.height - expected.height)) should] beLessThan:theValue(kPrecision)];
        [[theValue(askAgainSizeWithDifferentContainer.width) shouldNot] beGreaterThan:theValue(anotherContainerSize.width)];
        [[theValue(askAgainSizeWithDifferentContainer.height) shouldNot] beGreaterThan:theValue(anotherContainerSize.height)];
        [[@(fabs(askAgainSizeWithDifferentContainer.width - anotherExpectedSize.width)) should] beLessThan:theValue(kPrecision)];
        [[@(fabs(askAgainSizeWithDifferentContainer.height - anotherExpectedSize.height)) should] beLessThan:theValue(kPrecision)];
        [[theValue(nibSize.width) shouldNot] equal:theValue(askAgainSizeWithDifferentContainer.width)];
        [[theValue(nibSize.height) shouldNot] equal:theValue(askAgainSizeWithDifferentContainer.height)];
    });
});

SPEC_END
