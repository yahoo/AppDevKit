//
//  SampleHCollectionViewCell.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/22/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKCollectionViewDynamicSizeCell.h"

@interface SampleHCollectionViewCell : ADKCollectionViewDynamicSizeCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
