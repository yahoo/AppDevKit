//
//  UIImage+ADKColorReplacement.m
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/11/21.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Kiwi/Kiwi.h>
#import "ImageTestUtils.h"
#import "UIImage+ADKColorReplacement.h"

SPEC_BEGIN(UIImageADKColorReplacementSpec)

describe(@"test image:tintColor", ^{
    
    it(@"with hambuger image and tint color to blue", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-hambuger.png"];
        UIImage *blueImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected3.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected4.png"];
        
        UIImage *testImage = [UIImage ADKImage:originImage tintColor:[UIColor blueColor]];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:blueImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test image:replaceColor:", ^{

    it(@"with hambuger image and replace it color to red", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-hambuger.png"];
        UIImage *redImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];
        
        UIImage *testImage = [UIImage ADKImage:originImage replaceColor:[UIColor redColor]];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:redImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test image:replaceColor:withColor:", ^{

    it(@"with pattern image and replace red color to green color", ^{
        UIImage *redImage = [ImageTestUtils readImageNamed:@"img-red-pattern.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"img-green-pattern.png"];

        UIImage *testImage = [UIImage ADKImage:redImage
                               replaceColor:[UIColor redColor]
                                  withColor:[UIColor greenColor]];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(YES)];

        result = [ImageTestUtils compareImage:testImage toImage:redImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test imageNamed:tintColor:", ^{
    
    it(@"with hambuger image and tint color to blue", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-hambuger.png"];
        UIImage *blueImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected3.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected4.png"];
        
        [UIImage stub:@selector(imageNamed:) andReturn:originImage withArguments:@"icon-hambuger.png", nil];
        UIImage *testImage = [UIImage ADKImageNamed:@"icon-hambuger.png" tintColor:[UIColor blueColor]];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:blueImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test imageNamed:replaceColor:", ^{
    
    it(@"with hambuger image and replace color to red", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-hambuger.png"];
        UIImage *redImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];
        
        [UIImage stub:@selector(imageNamed:) andReturn:originImage withArguments:@"icon-hambuger.png", nil];
        UIImage *testImage = [UIImage ADKImageNamed:@"icon-hambuger.png" replaceColor:[UIColor redColor]];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:redImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test imageNamed:replaceColor:withColor:", ^{

    it(@"with pattern image and replace red color to green color", ^{
        UIImage *redImage = [ImageTestUtils readImageNamed:@"img-red-pattern.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"img-green-pattern.png"];

        [UIImage stub:@selector(imageNamed:) andReturn:redImage withArguments:@"img-red-pattern.png", nil];
        UIImage *testImage = [UIImage ADKImageNamed:@"img-red-pattern.png"
                                    replaceColor:[UIColor redColor]
                                       withColor:[UIColor greenColor]];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(YES)];

        result = [ImageTestUtils compareImage:testImage toImage:redImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test imageWithColor:size:", ^{
    
    it(@"with lbs image, color is brown, and size is equal to original image", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-lbs.png"];
        UIImage *brownImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected.png"];
        UIImage *yellowImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected2.png"];
        
        UIImage *testImage = [UIImage ADKImageWithColor:[UIColor brownColor] size:originImage.size];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:brownImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:yellowImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
    
    it(@"with lbs image, color is green, and size is equal to (original image / 2.0f)", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-lbs.png"];
        UIImage *halfImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected3.png"];
        UIImage *doubleImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected4.png"];
        
        UIImage *testImage = [UIImage ADKImageWithColor:[UIColor greenColor] size:CGSizeMake(originImage.size.width / 2.0f, originImage.size.height / 2.0f)];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:halfImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:doubleImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
    
    it(@"with lbs image, color is green, and size is equal to (original image * 2.0f)", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-lbs.png"];
        UIImage *halfImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected3.png"];
        UIImage *doubleImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected4.png"];
        
        UIImage *testImage = [UIImage ADKImageWithColor:[UIColor greenColor] size:CGSizeMake(originImage.size.width * 2.0f, originImage.size.height * 2.0f)];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:doubleImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:halfImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test image:colorWithAlphaComponent:", ^{
    
    it(@"with lbs image and alpha is 0.7f", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-lbs.png"];
        UIImage *firstAlphaImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected5.png"];
        UIImage *secondAlphaImage = [ImageTestUtils readImageNamed:@"icon-lbs-expected6.png"];
        
        UIImage *testImage = [UIImage ADKImage:originImage colorWithAlphaComponent:0.7f];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:firstAlphaImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:secondAlphaImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

SPEC_END
