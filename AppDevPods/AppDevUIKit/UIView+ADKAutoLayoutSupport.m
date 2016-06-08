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

- (void)hideView:(BOOL)isHidden withConstraints:(ADKLayoutAttribute)attributes
{
    ADKAutoLayoutValueObject *valueObject = self.cacheConstraintValueObject;
    if (isHidden) {
        if (attributes & ADKLayoutAttributeLeading) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeLeading];
            if (constraint.constant != 0.0f) {
                valueObject.cachedLeadingConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeTrailing) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeTrailing];
            if (constraint.constant != 0.0f) {
                valueObject.cachedTrailingConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeTop) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeTop];
            if (constraint.constant != 0.0f) {
                valueObject.cachedTopConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeBottom) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeBottom];
            if (constraint.constant != 0.0f) {
                valueObject.cachedBottomConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeWidth) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            CGSize viewSize = self.bounds.size;
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeWidth];
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
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeHeight];
            if (constraint.constant != 0.0f) {
                valueObject.cachedHeightConstraintConstant = viewSize.height;
                constraint.constant = 0.0f;
                self.hidden = isHidden;
            }
        }
    }
    else {
        if (attributes & ADKLayoutAttributeLeading) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeLeading];
            constraint.constant = valueObject.cachedLeadingConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeTrailing) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeTrailing];
            constraint.constant = valueObject.cachedTrailingConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeTop) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeTop];
            constraint.constant = valueObject.cachedTopConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeBottom) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeBottom];
            constraint.constant = valueObject.cachedBottomConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeWidth) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeWidth];
            constraint.constant = valueObject.cachedWidthConstraintConstant;
            self.hidden = isHidden;
        }
        if (attributes & ADKLayoutAttributeHeight) {
            NSLayoutConstraint *constraint = [self constraintForAttribute:NSLayoutAttributeHeight];
            constraint.constant = valueObject.cachedHeightConstraintConstant;
            self.hidden = isHidden;
        }
    }
}

- (void)hideViewWidth
{
    [self hideView:YES byAttribute:NSLayoutAttributeWidth];
}

- (void)unhideViewWidth
{
    [self hideView:NO byAttribute:NSLayoutAttributeWidth];
}

- (void)hideViewHeight
{
    [self hideView:YES byAttribute:NSLayoutAttributeHeight];
}

- (void)unhideViewHeight
{
    [self hideView:NO byAttribute:NSLayoutAttributeHeight];
}

- (void)hideTopConstraint
{
    [self hideView:YES byAttribute:NSLayoutAttributeTop];
}

- (void)unhideTopConstraint
{
    [self hideView:NO byAttribute:NSLayoutAttributeTop];
}

- (void)hideBottomConstraint
{
    [self hideView:YES byAttribute:NSLayoutAttributeBottom];
}

- (void)unhideBottomConstraint
{
    [self hideView:NO byAttribute:NSLayoutAttributeBottom];
}

- (void)hideLeadingConstraint
{
    [self hideView:YES byAttribute:NSLayoutAttributeLeading];
}

- (void)unhideLeadingConstraint
{
    [self hideView:NO byAttribute:NSLayoutAttributeLeading];
}

- (void)hideTrailingConstraint
{
    [self hideView:YES byAttribute:NSLayoutAttributeTrailing];
}

- (void)unhideTrailingConstraint
{
    [self hideView:NO byAttribute:NSLayoutAttributeTrailing];
}

- (void)hideView:(BOOL)hidden byAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self constraintForAttribute:attribute];

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
        [self setConstraintConstant:0.0f forAttribute:attribute];
    } else {
        // Restore constraint for unhidden
        if (attribute == NSLayoutAttributeWidth && self.cachedWidthConstraintConstant != 0.0f) {
            [self setConstraintConstant:self.cachedWidthConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeHeight && self.cachedHeightConstraintConstant != 0.0f) {
            [self setConstraintConstant:self.cachedHeightConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeTop) {
            [self setConstraintConstant:self.cachedTopConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeBottom) {
            [self setConstraintConstant:self.cachedBottomConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeLeading && self.cachedLeadingConstraintConstant != 0.0f) {
            [self setConstraintConstant:self.cachedLeadingConstraintConstant forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeTrailing && self.cachedLeadingConstraintConstant != 0.0f) {
            [self setConstraintConstant:self.cachedTrailingConstraintConstant forAttribute:attribute];
        }
    }

    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        self.hidden = hidden;
    }
}

- (void)setConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self constraintForAttribute:attribute];

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

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute
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
        return [self contentSizeConstraintForAttribute:attribute];
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

- (NSLayoutConstraint *)contentSizeConstraintForAttribute:(NSLayoutAttribute)attribute
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
