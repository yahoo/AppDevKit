//
//  ADKCellDynamicSizeCalculator.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/8/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKCellDynamicSizeCalculator.h"

@implementation ADKCellDynamicSizeCalculator

+ (instancetype)sharedInstance
{
    static ADKCellDynamicSizeCalculator *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[ADKCellDynamicSizeCalculator alloc] init];
        }
    });

    return instance;
}

- (CGSize)sizeForDynamicHeightCellInstance:(id)cellInstance preferredSize:(CGSize)preferredSize;
{
    if ([cellInstance isKindOfClass:[UICollectionViewCell class]] || [cellInstance isKindOfClass:[UITableViewCell class]]) {
        UIView *cell = cellInstance;
        cell.bounds = CGRectMake(0.0f, 0.0f, preferredSize.width, 0.0f);
        [cell layoutIfNeeded];
        UIView *contentView = [cell performSelector:@selector(contentView)];
        CGSize resultSize = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        resultSize.width = preferredSize.width;
        resultSize.height = MAX(resultSize.height, preferredSize.height);

        return resultSize;
    } else {
        return CGSizeZero;
    }
}

- (CGSize)sizeForDynamicWidthCellInstance:(id)cellInstance preferredSize:(CGSize)preferredSize;
{
    if ([cellInstance isKindOfClass:[UICollectionViewCell class]] || [cellInstance isKindOfClass:[UITableViewCell class]]) {
        UIView *cell = cellInstance;
        cell.bounds = CGRectMake(0.0f, 0.0f, 0.0f, preferredSize.height);
        [cell layoutIfNeeded];
        UIView *contentView = [cell performSelector:@selector(contentView)];
        CGSize resultSize = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        resultSize.width = MAX(resultSize.width, preferredSize.width);
        resultSize.height = preferredSize.height;

        return resultSize;
    } else {
        return CGSizeZero;
    }
}

@end
