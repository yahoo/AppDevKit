//
//  DynamicHeightCell.h
//  AppDevKit
//
//  Created by Jeff Lin on 3/19/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKCollectionViewDynamicSizeCell.h"

extern NSString * const DynamicHeightCellIdentifer;

@interface DynamicHeightCell : ADKCollectionViewDynamicSizeCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingViews;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
