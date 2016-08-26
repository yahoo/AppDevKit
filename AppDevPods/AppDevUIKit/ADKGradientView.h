//
//  ADKGradientView.h
//  AppDevKit
//
//  Created by Bram Yeh on 12/4/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

/**
 * @brief Drawing gradient effect from beginColor to endColor. The blensType can be use on decide draw direction.
 *
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ADKBlendsType) {
    ADKBlendsTypeFromTopToBottom = 0,
    ADKBlendsTypeFromLeftToRight,
    ADKBlendsTypeFromLeftTopToRightBottom,
    ADKBlendsTypeFromRightTopToLeftBottom
};

@interface ADKGradientView : UIView

/**
 * @brief Painting gradient start from specific UIColor.
 *
 */
@property (nonatomic, strong) UIColor *beginColor;

/**
 * @brief Painting gradient end at specific UIColor.
 *
 */
@property (nonatomic, strong) UIColor *endColor;

/**
 * @brief Decide how to paint gradient on this view.
 *
 */
@property (nonatomic, assign) ADKBlendsType blendsType;

@end

