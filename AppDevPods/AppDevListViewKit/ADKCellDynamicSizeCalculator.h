//
//  ADKCellDynamicSizeCalculator.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/8/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ADKCellDynamicSizeCalculator : NSObject

/**
 * @brief Geting a shared instance of ADKCellDynamicSizeCalculator.
 *
 * @return Instance of ADKCellDynamicSizeCalculator.
 */
+ (instancetype)sharedInstance;

/**
 * @brief This is a method for cell dynamic height calculation.
 *
 * @param cellInstance input the class instance, should be a instance of UICollectionViewCell or UITableViewCell.
 * @param preferredSize input the preferred cell size that it will be a minimal size when cell complete size calculation and cell size is not big enough.
 *
 * @return CGSize of the calculated result from cell instance.
 */
- (CGSize)sizeForDynamicHeightCellInstance:(id)cellInstance preferredSize:(CGSize)preferredSize;

/**
 * @brief This is a method for cell dynamic width calculation.
 *
 * @param cellInstance input the class instance, should be a instance of UICollectionViewCell or UITableViewCell.
 * @param preferredSize input the preferred cell size that it will be a minimal size when cell complete size calculation and cell size is not big enough.
 *
 * @return CGSize of the calculated result from cell instance.
 */
- (CGSize)sizeForDynamicWidthCellInstance:(id)cellInstance preferredSize:(CGSize)preferredSize;


@end
