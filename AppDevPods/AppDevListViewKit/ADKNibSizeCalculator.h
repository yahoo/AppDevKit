//
//  ADKNibSizeCalculator.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 10/21/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ADKCalculatorHelper.h"

typedef NS_ENUM(NSUInteger, ADKNibSizeStyle) {
    ADKNibOriginalSize = 0,
    ADKNibDefaultScaling,
    ADKNibBottomFixedScaling,
    ADKNibFixedHeightScaling,
    ADKNibCustomCalculation,
    ADKNibUncachedCustomCalculation
};

@protocol ADKNibSizeCustomCalculationProtocol <NSObject>

- (CGSize)sizeThatFitsWidth:(CGFloat)width;

@end

@interface ADKNibSizeCalculator : NSObject

/**
 * @brief Geting a shared instance of ADKNibSizeCalculator.
 *
 * @return Instance of ADKNibSizeCalculator.
 */
+ (instancetype)sharedInstance;

/**
 * @brief This is a method for nibsize calculation with default style.
 *
 * @param nibName input nibfile identifier, shoulf be in string.
 *
 * @return CGSize of the calculated nibfile.
 */
- (CGSize)sizeForNibNamed:(NSString *)nibName;

/**
 * @brief This is a method for nibsize calculation, various of calculation style parameter can be input here
 *
 * @param nibName input nibfile identifier, shoulf be in string
 *
 * @param style There are currently 5 types of style, as following:
 *        ADKNibOriginalSize = return original nibfile size,
 *                          e.g. input nibsize  = (320, 480),
 *                          output size = (320, 480),
 *                          used in little occations
 *      ADKNibDefaultScaling = return aspect ratio fill nibfile size,
 *                          e.g. input nibsize  = (320, 480) screenwidth = 640.0f,
 *                          output size = (640, 960),
 *                          often used for banner cells, text cells and pure pic cells
 * ADKNibBottomFixedScaling = return aspect scaled for the image part, but original height for the text field part nibfile size,
 *                          e.g. input nibsize  = (320, 480) screenwidth = 640.0f,
 *                          output size = (640, 800),
 *                          often used for largecell and discovery item cells
 *
 *  ADKNibFixedHeightScaling = return width scaled to screen, height fixed to nibsize,
 *                          e.g. input nibsize  = (320, 480) screenwidth = 640.0f,
 *                          output size = (640, 480),
 *                          often used for pure text cells, since fontsize does not scale up in autolayout
 *
 *  ADKNibCustomCalculation = return the size calculated by the nibfile's corresponding class' sizeThatFitsWidth: method
 *                          if the corresponding class doesn't conform to ADKNibSizeCustomCalculationProtocol, it would use ADKNibDefaultScaling instead
 *
 *  ADKNibUncachedCustomCalculation = the same as ADKNibCustomCalculation except that ADKNibUncachedCustomCalculation doesn't cache the calculated size
 *
 * @return CGSize of the calculated nibfile.
 */
- (CGSize)sizeForNibNamed:(NSString *)nibName withStyle:(ADKNibSizeStyle)style;

/**
 * @brief  Same as sizeForNibNamed:, use assigned size instead
 *
 * @param nibName input nibfile identifier, shoulf be in string
 *
 * @param style same as sizeForNibNamed:
 * 
 * @param containerSize bounds that nib file will fit.
 *
 * @return CGSize of the calculated nibfile.
*/
- (CGSize)sizeForNibNamed:(NSString *)nibName withStyle:(ADKNibSizeStyle)style fitSize:(CGSize)containerSize;


@end
