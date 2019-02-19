//
//  UIImage+ADKDrawingTemplateSpec.m
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

SPEC_BEGIN(UIImageADKDrawingTemplateSpec)

describe(@"Test UIImage+ADKDrawingTemplate", ^{

    __block NSString *pdfPath;

    context(@"For different size", ^{
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            pdfPath = [bundle pathForResource:@"img-pdf-assets" ofType:@"pdf"];
        });
        it(@"with pdf image assets and size 100x100", ^{
            UIImage *testImage = [UIImage ADKLosslessImageFromPDFPath:pdfPath size:CGSizeMake(100.0f, 100.0f)];
            UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-pdf-assets-expected.png"];
            UIImage *unexpectedImage = [ImageTestUtils readImageNamed:@"img-pdf-assets-expected2.png"];

            BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
            [[theValue(result) should] equal:theValue(YES)];

            result = [ImageTestUtils compareImage:testImage toImage:unexpectedImage];
            [[theValue(result) should] equal:theValue(NO)];
        });
        it(@"with pdf image assets and size 200x100", ^{
            UIImage *testImage = [UIImage ADKLosslessImageFromPDFPath:pdfPath size:CGSizeMake(200.0f, 100.0f)];
            UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-pdf-assets-expected2.png"];
            UIImage *unexpectedImage = [ImageTestUtils readImageNamed:@"img-pdf-assets-expected.png"];

            BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
            [[theValue(result) should] equal:theValue(YES)];

            result = [ImageTestUtils compareImage:testImage toImage:unexpectedImage];
            [[theValue(result) should] equal:theValue(NO)];
        });
    });
    it(@"with wrong pdf path", ^{
        UIImage *testImage = [UIImage ADKLosslessImageFromPDFPath:@"wrongPath.pdf" size:CGSizeMake(100.0f, 100.0f)];
        UIImage *expectedImage = [ImageTestUtils readImageNamed:@"img-pdf-assets-expected3.png"];

        BOOL result = [ImageTestUtils compareImage:testImage toImage:expectedImage];
        [[theValue(result) should] equal:theValue(YES)];
    });
});

SPEC_END
