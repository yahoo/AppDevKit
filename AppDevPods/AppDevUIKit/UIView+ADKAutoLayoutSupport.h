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
- (void)ADKHideView:(BOOL)isHidden withConstraints:(ADKLayoutAttribute)attributes;

/**
 * @brief Support auto layout to hide view's width.
 */
- (void)ADKHideViewWidth;

/**
 * @brief Support auto layout to unhide view's width.
 */
- (void)ADKUnhideViewWidth;

/**
 * @brief Support auto layout to hide view's height.
 */
- (void)ADKHideViewHeight;

/**
 * @brief Support auto layout to unhide view's height.
 */
- (void)ADKUnhideViewHeight;

/**
 * @brief Support auto layout to hide view's top constraint.
 */
- (void)ADKHideTopConstraint;

/**
 * @brief Support auto layout to unhide view's top constraint.
 */
- (void)ADKUnhideTopConstraint;

/**
 * @brief Support auto layout to hide view's bottom constraint.
 */
- (void)ADKHideBottomConstraint;

/**
 * @brief Support auto layout to unhide view's bottom constraint.
 */
- (void)ADKUnhideBottomConstraint;

/**
 * @brief Support auto layout to hide view's leading constraint.
 */
- (void)ADKHideLeadingConstraint;

/**
 * @brief Support auto layout to unhide view's leading constraint.
 */
- (void)ADKUnhideLeadingConstraint;

/**
 * @brief Support auto layout to hide view's trailing constraint.
 */
- (void)ADKHideTrailingConstraint;

/**
 * @brief Support auto layout to unhide view's trailing constraint.
 */
- (void)ADKUnhideTrailingConstraint;

/**
 * @brief Support auto layout to set constraint constant on view easily.
 *
 * @param constant Set view's constraint constant with CGFloat.
 * @param attribute Set view's attribute with NSLayoutAttribute.
 */
- (void)ADKSetConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute;

/**
 * @brief Support auto layout to get NSLayoutConstraint instance on view easily.
 *
 * @param attribute Set view's attribute with NSLayoutAttribute.
 */
- (NSLayoutConstraint *)ADKConstraintForAttribute:(NSLayoutAttribute)attribute;

@end
