//
//  UIView+ADKAutoLayoutSupport.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 3/30/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <objc/runtime.h>
#import "UIView+ADKAutoLayoutSupport.h"
#import "ADKAutoLayoutValueObject.h"

@interface UIView ()

@property (assign, nonatomic) CGFloat initializedMargin;
@property (assign, nonatomic) CGFloat cachedWidthConstraintConstant;
@property (assign, nonatomic) CGFloat cachedHeightConstraintConstant;
@property (assign, nonatomic) CGFloat cachedTopConstraintConstant;
@property (assign, nonatomic) CGFloat cachedBottomConstraintConstant;
@property (assign, nonatomic) CGFloat cachedLeadingConstraintConstant;
@property (assign, nonatomic) CGFloat cachedTrailingConstraintConstant;
@property (assign, nonatomic) ADKAutoLayoutValueObject *cacheConstraintValueObject;

@end


@implementation UIView (ADKAutoLayoutSupport)

NSString * const initializedMarginKey;
NSString * const cachedWidthConstraintConstantKey;
NSString * const cachedHeightConstraintConstantKey;
NSString * const cachedTopConstraintConstantKey;
NSString * const cachedBottomConstraintConstantKey;
NSString * const cachedLeadingConstraintConstantKey;
NSString * const cachedTrailingConstraintConstantKey;

NSString * const valueObjectConstantKey;


#pragma mark - Getter and Setter

- (void)setCacheConstraintValueObject:(ADKAutoLayoutValueObject *)cacheConstraintValueObject
{
    objc_setAssociatedObject(self, &valueObjectConstantKey, cacheConstraintValueObject, OBJC_ASSOCIATION_RETAIN);
}

- (ADKAutoLayoutValueObject *)cacheConstraintValueObject
{
    ADKAutoLayoutValueObject *obj = objc_getAssociatedObject(self, &valueObjectConstantKey);
    if (!obj) {
        obj = [[ADKAutoLayoutValueObject alloc] init];
        self.cacheConstraintValueObject = obj;
    }
    return obj;
}

- (void)setInitializedMargin:(CGFloat)initializedMargin
{
    self.cacheConstraintValueObject.initializedMargin = initializedMargin;
}

- (CGFloat)initializedMargin
{
    return self.cacheConstraintValueObject.initializedMargin;
}

- (void)setCachedWidthConstraintConstant:(CGFloat)cachedWidthConstraintConstant
{
    self.cacheConstraintValueObject.cachedWidthConstraintConstant = cachedWidthConstraintConstant;
}

- (CGFloat)cachedWidthConstraintConstant
{
    return self.cacheConstraintValueObject.cachedWidthConstraintConstant;
}

- (void)setCachedHeightConstraintConstant:(CGFloat)cachedHeightConstraintConstant
{
    self.cacheConstraintValueObject.cachedHeightConstraintConstant = cachedHeightConstraintConstant;
}

- (CGFloat)cachedHeightConstraintConstant
{
    return self.cacheConstraintValueObject.cachedHeightConstraintConstant;
}

- (void)setCachedTopConstraintConstant:(CGFloat)cachedTopConstraintConstant
{
    self.cacheConstraintValueObject.cachedTopConstraintConstant = cachedTopConstraintConstant;
}

- (CGFloat)cachedTopConstraintConstant
{
    return self.cacheConstraintValueObject.cachedTopConstraintConstant;
}

- (void)setCachedBottomConstraintConstant:(CGFloat)cachedBottomConstraintConstant
{
    self.cacheConstraintValueObject.cachedBottomConstraintConstant = cachedBottomConstraintConstant;
}

- (CGFloat)cachedBottomConstraintConstant
{
    return self.cacheConstraintValueObject.cachedBottomConstraintConstant;
}

- (void)setCachedLeadingConstraintConstant:(CGFloat)cachedLeadingConstraintConstant
{
    self.cacheConstraintValueObject.cachedLeadingConstraintConstant = cachedLeadingConstraintConstant;
}

- (CGFloat)cachedLeadingConstraintConstant
{
    return self.cacheConstraintValueObject.cachedLeadingConstraintConstant;
}

- (void)setCachedTrailingConstraintConstant:(CGFloat)cachedTrailingConstraintConstant
{
    self.cacheConstraintValueObject.cachedTrailingConstraintConstant = cachedTrailingConstraintConstant;
}

- (CGFloat)cachedTrailingConstraintConstant
{
    return self.cacheConstraintValueObject.cachedTrailingConstraintConstant;
}


#pragma mark - Support methods

- (void)ADKHideView:(BOOL)isHidden withConstraints:(ADKLayoutAttribute)attributes
{
    ADKAutoLayoutValueObject *valueObject = self.cacheConstraintValueObject;
    if (isHidden) {
        if (attributes & ADKLayoutAttributeLeading) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeLeading];
            if (constraint.constant != 0.0f) {
                valueObject.cachedLeadingConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeTrailing) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTrailing];
            if (constraint.constant != 0.0f) {
                valueObject.cachedTrailingConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeTop) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTop];
            if (constraint.constant != 0.0f) {
                valueObject.cachedTopConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeBottom) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeBottom];
            if (constraint.constant != 0.0f) {
                valueObject.cachedBottomConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeWidth) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            CGSize viewSize = self.bounds.size;
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeWidth];
            if (constraint.constant != 0.0f) {
                valueObject.cachedWidthConstraintConstant = viewSize.width;
                constraint.constant = 0.0f;
                self.hidden = isHidden;
            }
        }
        if (attributes & ADKLayoutAttributeHeight) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            CGSize viewSize = self.bounds.size;
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeHeight];
            if (constraint.constant != 0.0f) {
                valueObject.cachedHeightConstraintConstant = viewSize.height;
                constraint.constant = 0.0f;
                self.hidden = isHidden;
            }
        }
    }
    else {
        if (attributes & ADKLayoutAttributeLeading) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeLeading];
            constraint.constant = valueObject.cachedLeadingConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeTrailing) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTrailing];
            constraint.constant = valueObject.cachedTrailingConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeTop) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTop];
            constraint.constant = valueObject.cachedTopConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeBottom) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeBottom];
            constraint.constant = valueObject.cachedBottomConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeWidth) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeWidth];
            constraint.constant = valueObject.cachedWidthConstraintConstant;
            self.hidden = isHidden;
        }
        if (attributes & ADKLayoutAttributeHeight) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeHeight];
            constraint.constant = valueObject.cachedHeightConstraintConstant;
            self.hidden = isHidden;
        }
    }
}

- (void)ADKHideViewWidth
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeWidth];
}

- (void)ADKUnhideViewWidth
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeWidth];
}

- (void)ADKHideViewHeight
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeHeight];
}

- (void)ADKUnhideViewHeight
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeHeight];
}

- (void)ADKHideTopConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeTop];
}

- (void)ADKUnhideTopConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeTop];
}

- (void)ADKHideBottomConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeBottom];
}

- (void)ADKUnhideBottomConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeBottom];
}

- (void)ADKHideLeadingConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeLeading];
}

- (void)ADKUnhideLeadingConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeLeading];
}

- (void)ADKHideTrailingConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeTrailing];
}

- (void)ADKUnhideTrailingConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeTrailing];
}

- (void)ADKHideView:(BOOL)hidden byAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:attribute];

    if (hidden) {
        if (constraint && constraint.constant > 0.0f) {
            // Cache constraint's value
            if (attribute == NSLayoutAttributeWidth) {
                self.cachedWidthConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeHeight) {
                self.cachedHeightConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeTop) {
                self.cachedTopConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeBottom) {
                self.cachedBottomConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeLeading) {
                self.cachedLeadingConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeTrailing) {
                self.cachedTrailingConstraintConstant = constraint.constant;
            }
        } else {
            // Calculate by yourself (No one set constraint for this view)
            [self setNeedsLayout];
            [self layoutIfNeeded];
            CGSize viewSize = self.bounds.size;
            if (attribute == NSLayoutAttributeWidth && viewSize.width > 0.0f) {
                self.cachedWidthConstraintConstant = viewSize.width;
            } else if (attribute == NSLayoutAttributeHeight && viewSize.height > 0.0f) {
                self.cachedHeightConstraintConstant = viewSize.height;
            }
            // Top, Bottom, Leading, Trailing can not be calculated.
        }

        // Set up new constraint for hidden
        [self setADKConstraintConstant:0.0f forAttribute:attribute];
    } else {
        // Restore constraint for unhidden
        if (attribute == NSLayoutAttributeWidth && self.cachedWidthConstraintConstant != 0.0f) {
            [self setADKConstraintConstant:self.cachedWidthConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeHeight && self.cachedHeightConstraintConstant != 0.0f) {
            [self setADKConstraintConstant:self.cachedHeightConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeTop) {
            [self setADKConstraintConstant:self.cachedTopConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeBottom) {
            [self setADKConstraintConstant:self.cachedBottomConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeLeading && self.cachedLeadingConstraintConstant != 0.0f) {
            [self setADKConstraintConstant:self.cachedLeadingConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeTrailing && self.cachedLeadingConstraintConstant != 0.0f) {
            [self setADKConstraintConstant:self.cachedTrailingConstraintConstant forAttribute:attribute];
        }
    }

    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        self.hidden = hidden;
    }
}

- (void)setADKConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:attribute];

    if (constraint) {
        constraint.constant = constant;
    } else {
        [self.superview addConstraint: [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:attribute
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:constant]];
    }
}

- (NSLayoutConstraint *)ADKConstraintForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d && class == %@", self, attribute, [NSLayoutConstraint class]];
    NSArray *predicatedArray;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        predicatedArray = [self.constraints filteredArrayUsingPredicate:predicate];
    } else {
        predicatedArray = [self.superview.constraints filteredArrayUsingPredicate:predicate];
    }

    if (predicatedArray.count > 0) {
        return predicatedArray.firstObject;
    } else {
        NSLayoutConstraint *reverseConstraint = [self handleReversedCaseForAttribute:attribute];
        if (reverseConstraint) {
            return reverseConstraint;
        }
        // No constraint found, try to use NSContentSizeLayoutConstraint instead.
        return [self contentSizeADKConstraintForAttribute:attribute];
    }
}

- (NSLayoutConstraint *)handleReversedCaseForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"secondItem = %@ && secondAttribute = %d && class == %@", self, attribute, [NSLayoutConstraint class]];
    NSArray *predicatedArray;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        predicatedArray = [self.constraints filteredArrayUsingPredicate:predicate];
    } else {
        predicatedArray = [self.superview.constraints filteredArrayUsingPredicate:predicate];
    }
    
    return predicatedArray.firstObject;
}

- (NSLayoutConstraint *)contentSizeADKConstraintForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d", self, attribute];
    NSArray *predicatedArray;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        predicatedArray = [self.constraints filteredArrayUsingPredicate:predicate];
    } else {
        predicatedArray = [self.superview.constraints filteredArrayUsingPredicate:predicate];
    }
    
    if (predicatedArray.count > 0) {
        return predicatedArray.firstObject;
    } else {
        return nil;
    }
}

@end
