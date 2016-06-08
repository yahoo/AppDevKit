//
//  UIView+ADKAutoLayoutSupport.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 3/30/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ADKLayoutAttribute) {
    ADKLayoutAttributeTop = 1 << 0,
    ADKLayoutAttributeBottom = 1 << 1,
    ADKLayoutAttributeLeading = 1 << 2,
    ADKLayoutAttributeTrailing = 1 << 3,
    ADKLayoutAttributeWidth = 1 << 4,
    ADKLayoutAttributeHeight = 1 << 5,
};

@interface UIView (ADKAutoLayoutSupport)


@property (assign, nonatomic) CGFloat initializedMargin;

/**
 *  @brief Hide/unhide view and it's constraint, e.g. ADKLayoutAttributeBottom | ADKLayoutAttributeHeight will handle both bottom constraint and height constraint
 *
 *  @param isHidden   View will hide for YES, show for NO
 *  @param attributes Constraints will be affect, please reference ADKLayoutAttribute
 */
- (void)hideView:(BOOL)isHidden withConstraints:(ADKLayoutAttribute)attributes;

/**
 * @brief Support auto layout to hide view's width.
 */
- (void)hideViewWidth;

/**
 * @brief Support auto layout to unhide view's width.
 */
- (void)unhideViewWidth;

/**
 * @brief Support auto layout to hide view's height.
 */
- (void)hideViewHeight;

/**
 * @brief Support auto layout to unhide view's height.
 */
- (void)unhideViewHeight;

/**
 * @brief Support auto layout to hide view's top constraint.
 */
- (void)hideTopConstraint;

/**
 * @brief Support auto layout to unhide view's top constraint.
 */
- (void)unhideTopConstraint;

/**
 * @brief Support auto layout to hide view's bottom constraint.
 */
- (void)hideBottomConstraint;

/**
 * @brief Support auto layout to unhide view's bottom constraint.
 */
- (void)unhideBottomConstraint;

/**
 * @brief Support auto layout to hide view's leading constraint.
 */
- (void)hideLeadingConstraint;

/**
 * @brief Support auto layout to unhide view's leading constraint.
 */
- (void)unhideLeadingConstraint;

/**
 * @brief Support auto layout to hide view's trailing constraint.
 */
- (void)hideTrailingConstraint;

/**
 * @brief Support auto layout to unhide view's trailing constraint.
 */
- (void)unhideTrailingConstraint;

/**
 * @brief Support auto layout to set constraint constant on view easily.
 *
 * @param constant Set view's constraint constant with CGFloat.
 * @param attribute Set view's attribute with NSLayoutAttribute.
 */
- (void)setConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute;

/**
 * @brief Support auto layout to get NSLayoutConstraint instance on view easily.
 *
 * @param attribute Set view's attribute with NSLayoutAttribute.
 */
- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute;

@end
