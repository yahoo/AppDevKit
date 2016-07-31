//
//  AvatorCollectionViewCell.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/10/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "AvatorCollectionViewCell.h"

@implementation AvatorCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setComponment];
}

- (void)setComponment
{
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.bounds) * 0.5f;
}


@end
