//
//  UIView+ADKAutoLayoutSupportSpec.m
//  AppDevKit
//
//  Created by Jeff Lin on 3/13/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <Kiwi.h>
#import "AppDevUIKit.h"
#import "AutoLayoutSupportTestView.h"

SPEC_BEGIN(ADKAutoLayoutSupportSpec)

describe(@"Test ADKHideView:withConstraints:", ^{
    __block AutoLayoutSupportTestView *testView;
    
    beforeEach(^{
        testView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"AutoLayoutSupportTestView" owner:self options:nil] lastObject];
    });
    
    context(@"test single operation", ^{
        it(@"test hide ADKLayoutAttributeTop", ^{
            [[testView shouldNot] beNil];
            CGRect expectRect = CGRectOffset(testView.buttomView.frame, 0.0f, -30.0f);
            [testView.centerView ADKHideView:YES withConstraints:ADKLayoutAttributeTop];
            [testView setNeedsLayout];
            [testView layoutIfNeeded];
            [[theValue(testView.buttomView.frame) should] equal:theValue(expectRect)];
        });
        
        it(@"test hide ADKLayoutAttributeLeading", ^{
            [[testView shouldNot] beNil];
            CGRect expectRect = CGRectOffset(testView.centerView.frame, -30.0f, 0.0f);
            [testView.centerView ADKHideView:YES withConstraints:ADKLayoutAttributeLeading];
            [testView setNeedsLayout];
            [testView layoutIfNeeded];
            [[theValue(testView.centerView.frame) should] equal:theValue(expectRect)];
        });
        
        it(@"test hide ADKLayoutAttributeTrailing", ^{
            [[testView shouldNot] beNil];
            CGRect expectRect = CGRectOffset(testView.rightView.frame, -60.0f, 0.0f);
            [testView.centerView ADKHideView:YES withConstraints:ADKLayoutAttributeTrailing];
            [testView setNeedsLayout];
            [testView layoutIfNeeded];
            [[theValue(testView.rightView.frame) should] equal:theValue(expectRect)];
        });
        
        it(@"test hide ADKLayoutAttributeBottom", ^{
            [[testView shouldNot] beNil];
            CGRect expectRect = CGRectOffset(testView.buttomView.frame, 0.0f, -15.0f);
            [testView.centerView ADKHideView:YES withConstraints:ADKLayoutAttributeBottom];
            [testView setNeedsLayout];
            [testView layoutIfNeeded];
            [[theValue(testView.buttomView.frame) should] equal:theValue(expectRect)];
        });
        
        it(@"test hide ADKLayoutAttributeWidth", ^{
            [[testView shouldNot] beNil];
            CGRect rightExpectRect = CGRectOffset(testView.rightView.frame, -50.0f, 0.0f);
            CGRect buttomExpectRect = CGRectOffset(testView.buttomView.frame, 0.0f, 0.0f);
            [testView.centerView ADKHideView:YES withConstraints:ADKLayoutAttributeWidth];
            [testView setNeedsLayout];
            [testView layoutIfNeeded];
            [testView layoutSubviews];
            [[theValue(testView.rightView.frame) should] equal:theValue(rightExpectRect)];
            [[theValue(testView.buttomView.frame) should] equal:theValue(buttomExpectRect)];
        });
        
        it(@"test hide ADKLayoutAttributeHeight", ^{
            [[testView shouldNot] beNil];
            CGRect rightExpectRect = CGRectOffset(testView.rightView.frame, 0.0f, 0.0f);
            CGRect buttomExpectRect = CGRectOffset(testView.buttomView.frame, 0.0f, -50.0f);
            [testView.centerView ADKHideView:YES withConstraints:ADKLayoutAttributeHeight];
            [testView setNeedsLayout];
            [testView layoutIfNeeded];
            [testView layoutSubviews];
            [[theValue(testView.rightView.frame) should] equal:theValue(rightExpectRect)];
            [[theValue(testView.buttomView.frame) should] equal:theValue(buttomExpectRect)];
        });
    });

});

describe(@"test ADKHideTopConstraint", ^{
    __block AutoLayoutSupportTestView *testView;
    
    beforeEach(^{
        testView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"AutoLayoutSupportTestView" owner:self options:nil] lastObject];
    });
    
    it(@"test single operation", ^{
        [[testView shouldNot] beNil];
        CGRect expectRect = CGRectOffset(testView.buttomView.frame, 0.0f, -30.0f);
        [testView.centerView ADKHideTopConstraint];
        [testView setNeedsLayout];
        [testView layoutIfNeeded];
        [[theValue(testView.buttomView.frame) should] equal:theValue(expectRect)];
    });
});

describe(@"test ADKHideLeadingConstraint", ^{
    __block AutoLayoutSupportTestView *testView;
    
    beforeEach(^{
        testView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"AutoLayoutSupportTestView" owner:self options:nil] lastObject];
    });
    
    it(@"test single operation", ^{
        [[testView shouldNot] beNil];
        CGRect expectRect = CGRectOffset(testView.centerView.frame, -30.0f, 0.0f);
        [testView.centerView ADKHideLeadingConstraint];
        [testView setNeedsLayout];
        [testView layoutIfNeeded];
        [[theValue(testView.centerView.frame) should] equal:theValue(expectRect)];
    });
});

describe(@"test ADKHideTrailingConstraint", ^{
    __block AutoLayoutSupportTestView *testView;
    
    beforeEach(^{
        testView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"AutoLayoutSupportTestView" owner:self options:nil] lastObject];
    });
    
    it(@"test single operation", ^{
        [[testView shouldNot] beNil];
        CGRect expectRect = CGRectOffset(testView.rightView.frame, -60.0f, 0.0f);
        [testView.centerView ADKHideTrailingConstraint];
        [testView setNeedsLayout];
        [testView layoutIfNeeded];
        [[theValue(testView.rightView.frame) should] equal:theValue(expectRect)];
    });
});

describe(@"test ADKHideBottomConstraint", ^{
    __block AutoLayoutSupportTestView *testView;
    
    beforeEach(^{
        testView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"AutoLayoutSupportTestView" owner:self options:nil] lastObject];
    });
    
    it(@"test single operation", ^{
        [[testView shouldNot] beNil];
        CGRect expectRect = CGRectOffset(testView.buttomView.frame, 0.0f, -15.0f);
        [testView.centerView ADKHideBottomConstraint];
        [testView setNeedsLayout];
        [testView layoutIfNeeded];
        [[theValue(testView.buttomView.frame) should] equal:theValue(expectRect)];
    });
});

describe(@"test ADKHideViewWidth", ^{
    __block AutoLayoutSupportTestView *testView;
    
    beforeEach(^{
        testView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"AutoLayoutSupportTestView" owner:self options:nil] lastObject];
    });
    
    it(@"test single operation", ^{
        [[testView shouldNot] beNil];
        CGRect rightExpectRect = CGRectOffset(testView.rightView.frame, -50.0f, 0.0f);
        CGRect buttomExpectRect = CGRectOffset(testView.buttomView.frame, 0.0f, 0.0f);
        [testView.centerView ADKHideViewWidth];
        [testView setNeedsLayout];
        [testView layoutIfNeeded];
        [testView layoutSubviews];
        [[theValue(testView.rightView.frame) should] equal:theValue(rightExpectRect)];
        [[theValue(testView.buttomView.frame) should] equal:theValue(buttomExpectRect)];
    });
});

describe(@"test ADKHideViewHeight", ^{
    __block AutoLayoutSupportTestView *testView;
    
    beforeEach(^{
        testView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"AutoLayoutSupportTestView" owner:self options:nil] lastObject];
    });
    
    it(@"test single operation", ^{
        [[testView shouldNot] beNil];
        CGRect rightExpectRect = CGRectOffset(testView.rightView.frame, 0.0f, 0.0f);
        CGRect buttomExpectRect = CGRectOffset(testView.buttomView.frame, 0.0f, -50.0f);
        [testView.centerView ADKHideViewHeight];
        [testView setNeedsLayout];
        [testView layoutIfNeeded];
        [testView layoutSubviews];
        [[theValue(testView.rightView.frame) should] equal:theValue(rightExpectRect)];
        [[theValue(testView.buttomView.frame) should] equal:theValue(buttomExpectRect)];
    });
});

SPEC_END