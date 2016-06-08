//
//  UIImage+ADKImageFilterSpec.m
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/11/24.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Kiwi/Kiwi.h>
#import "ImageTestUtils.h"
#import "UIImage+ADKImageFilter.h"

SPEC_BEGIN(UIImageADKImageFilterSpec)

describe(@"test captureView:", ^{
    // NOTE: This tes case should re-think how to test it.
//    it(@"with adding line icon to a view, and mainScreen.scale is 1", ^{
//        UIImageView *originImageView = [[UIImageView alloc] initWithImage:[ImageTestUtils readImageNamed:@"icon-line-share.png"]];
//        UIView *testView = [[UIView alloc] initWithFrame:originImageView.frame];
//        [testView addSubview:originImageView];
//        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"icon-line-share-expected3.png"];
//        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];
//
//        [[UIScreen mainScreen] stub:@selector(scale) andReturn:theValue(1)];
//        UIImage *testImage = [UIImage captureView:testView];
//
//        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
//        [[theValue(result) should] equal:theValue(YES)];
//
//        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
//        [[theValue(result) should] equal:theValue(NO)];
//    });
    
    it(@"with adding personalization-reminder image to a view, and mainScreen.scale is 2", ^{
        UIImageView *originImageView = [[UIImageView alloc] initWithImage:[ImageTestUtils readImageNamed:@"img-personalization-reminder.png"]];
        UIView *testView = [[UIView alloc] initWithFrame:originImageView.frame];
        [testView addSubview:originImageView];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder-expected3.png" scale:2.0f];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];

        [[UIScreen mainScreen] stub:@selector(scale) andReturn:theValue(2)];
        UIImage *testImage = [UIImage ADKCaptureView:testView];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test ADKCaptureView:withFrame", ^{
    
    it(@"with snapshot-before image and snapshot frame is (100, 100, 300, 300)", ^{
        [[UIScreen mainScreen] stub:@selector(scale) andReturn:theValue(1)];
        UIImage *originalImage = [ImageTestUtils readImageNamed:@"img-cropRect-before.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-cropRect-after.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];
        
        UIImageView *originCaptureView = [[UIImageView alloc] initWithImage:originalImage];
        UIImage *testImage = [UIImage ADKCaptureView:originCaptureView withFrame:CGRectMake(100.0f, 100.0f, 300.0f, 300.0f)];
        
        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] beYes];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] beNo];
    });
});

describe(@"test ADKResizeByMaxLength:", ^{
    
    it(@"with personalization-reminder-vertical (width < height) image and max size is 100", ^{

        UIImage *originImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder-vertical.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder-vertical-expected.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];

        [[UIScreen mainScreen] stub:@selector(scale) andReturn:theValue(1)];
        UIImage *testImage = [originImage ADKResizeByMaxLength:100];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
    
    it(@"with personalization-reminder-vertical (width > height) image and max size is 50", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder-expected.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];

        [[UIScreen mainScreen] stub:@selector(scale) andReturn:theValue(1)];
        UIImage *testImage = [originImage ADKResizeByMaxLength:50];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test cropSize:", ^{
    
    it(@"with line-share image and cropSize is (origin.size / 2.0f)", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-line-share.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"icon-line-share-expected.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];

        UIImage *testImage = [originImage ADKCropSize:CGSizeMake(originImage.size.width / 2.0f, originImage.size.height / 2.0f)];
        
        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test cropRect:", ^{

    it(@"with cropRect-before image and cropRect is (100, 100, 300, 300)", ^{
        UIImage *originalImage = [ImageTestUtils readImageNamed:@"img-cropRect-before.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-cropRect-after.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];

        UIImage *testImage = [originalImage ADKCropRect:CGRectMake(100.0f, 100.0f, 300.0f, 300.0f)];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] beYes];

        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] beNo];
    });
});

describe(@"test gaussianBlurWithRadius:", ^{
    
    it(@"with personalization-reminder image, radius is 5, and mainScreen.scale is 1", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder-expected2.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];

        [[UIScreen mainScreen] stub:@selector(scale) andReturn:theValue(1)];
        UIImage *testImage = [originImage ADKGaussianBlurWithRadius:5];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
    
    it(@"with personalization-reminder image, radius is 7, and image.scale is 2", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder.png" scale:2.0f];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-personalization-reminder-expected4.png" scale:2.0f];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];
        
        UIImage *testImage = [originImage ADKGaussianBlurWithRadius:7];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test maskImageWithColor:", ^{
    
    it(@"with lbs icon and color is yellow with 0.5 alpha", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-lbs.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"icon-lbs-and-yellow.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];
        
        UIImage *testImage = [originImage ADKMaskImageWithColor:[[UIColor yellowColor] colorWithAlphaComponent:0.5f]];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test overlayWithTexture:", ^{
    
    it(@"with hambuger image and texture image is lbs icon", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-hambuger.png"];
        UIImage *textureImage = [ImageTestUtils readImageNamed:@"icon-lbs.png"];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"icon-hambuger-and-lbs.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];
        
        UIImage *testImage = [originImage ADKOverlayWithTexture:textureImage];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
        
        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

describe(@"test blackAndWhiteImage", ^{

    it(@"with hambuger image", ^{
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-hambuger.png"];
        UIImage *blackAndWhiteImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected5.png"];
        UIImage *greenImage = [ImageTestUtils readImageNamed:@"icon-hambuger-expected2.png"];

        UIImage *testImage = [originImage ADKBlackAndWhiteImage];
        BOOL result = [ImageTestUtils compareImage:testImage toImage:blackAndWhiteImage];
        [[theValue(result) should] equal:theValue(YES)];

        result = [ImageTestUtils compareImage:testImage toImage:greenImage];
        [[theValue(result) should] equal:theValue(NO)];
    });
});

SPEC_END
