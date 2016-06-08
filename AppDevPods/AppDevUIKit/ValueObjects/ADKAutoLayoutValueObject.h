//
//  ADKAutoLayoutValueObject.h
//  AppDevKit
//
//  Created by Jeff Lin on 12/2/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ADKAutoLayoutValueObject : NSObject

@property (assign, nonatomic) CGFloat initializedMargin;
@property (assign, nonatomic) CGFloat cachedWidthConstraintConstant;
@property (assign, nonatomic) CGFloat cachedHeightConstraintConstant;
@property (assign, nonatomic) CGFloat cachedTopConstraintConstant;
@property (assign, nonatomic) CGFloat cachedBottomConstraintConstant;
@property (assign, nonatomic) CGFloat cachedLeadingConstraintConstant;
@property (assign, nonatomic) CGFloat cachedTrailingConstraintConstant;

@end
