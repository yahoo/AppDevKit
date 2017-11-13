//
//  SampleVCollectionViewCell.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/9/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <QuartzCore/QuartzCore.h>
#import "SampleVCollectionViewCell.h"
#import "UIColor+ThemeColor.h"
#import "ThemeManager.h"

@interface SampleVCollectionViewCell ()

@property (strong, nonatomic) CALayer *borderLayer;

@end

@implementation SampleVCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setComponment];

    self.borderLayer = [CALayer layer];
    self.borderLayer.backgroundColor = [UIColor themeBorderColor].CGColor;
    [self.contentView.layer addSublayer:self.borderLayer];
}

- (void)setComponment
{
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.bounds) * 0.5f;
}

- (void)prepareForReuse
{
    // If you need to modify some calculation for adjusting layouts, you can put you code here. ADKCellDynamicSizeCalulator will invoice prepareForReuse method automatically.
    // self.cellTopConstraint.constant = 50.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat borderWidth = CGRectGetWidth(self.frame);
    CGFloat borderHeight = 1.0f;
    CGFloat borderX = 0.0f;
    CGFloat borderY = CGRectGetHeight(self.frame) - borderHeight;

    [CATransaction begin];
    [CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
    self.borderLayer.frame = CGRectMake(borderX, borderY, borderWidth, borderHeight);
    [CATransaction commit];
}

@end
