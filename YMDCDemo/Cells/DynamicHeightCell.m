//
//  DynamicHeightCell.m
//  AppDevKit
//
//  Created by Jeff Lin on 3/19/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "DynamicHeightCell.h"
#import "UIColor+ADKHexPresentation.h"

NSString * const DynamicHeightCellIdentifer = @"DynamicHeightCell";

@implementation DynamicHeightCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textColor = [UIColor ADKColorWithHexNumber:0x999999];
    self.descriptionLabel.textColor = [UIColor whiteColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.ratingViews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = [UIImage imageNamed:@"star"];
    }];
}

@end
