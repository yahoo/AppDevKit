//
//  ADKCalculatorHelper.h
//  AppDevKit
//
//  Created by Jeff Lin on 5/21/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @brief Get random float value between bound.
 *
 *  @param maxBound The unmber of maximal limitation in range.
 *  @param minBound The unmber of minimal limitation in range.
 *
 *  @return return random value between specific range.
 */
CGFloat ADKRandomFloatNumber(CGFloat maxBound, CGFloat minBound);

/**
 *  @brief Calculate currect discount level.
 *
 *  @param price            sell price.
 *  @param marketPrice      origin price.
 *
 *  @return 0.0 for no discount, NAN for marketPrice <= price or 0.1%.
 */
CGFloat ADKGetDiscountFromPrices(CGFloat price, CGFloat marketPrice);

/**
 *  @brief change the input frame's height to zero.
 *
 *  @param Frame  input a CGRect Frame.
 *
 *  @return original width, zero height CGRect.
 */
CGRect ADKShrinkToZeroHeight(CGRect Frame);

/**
 *  @brief change the input frame's width to screen wide.
 *
 *  @param Frame  input a CGRect Frame.
 *
 *  @return original height, screen wide CGRect.
 */
CGRect ADKExtendToScreenWidth(CGRect Frame);

/**
 *  @brief return a device's CGSize with screen wide but zero height.
 *
 *  @return Expected CGSize.
 */
CGSize ADKCGSizeZeroHeight();

/**
 *  @brief return a device's screen size.
 *
 *  @return Expected CGSize.
 */
CGSize ADKScreenSize();
