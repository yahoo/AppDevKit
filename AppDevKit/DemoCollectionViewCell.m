//
//  DemoCollectionViewCell.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/9/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <QuartzCore/QuartzCore.h>
#import "DemoCollectionViewCell.h"
#import "UIColor+ThemeColor.h"


@interface DemoCollectionViewCell()

@property (strong, nonatomic) CALayer *borderLayer;

@end

@implementation DemoCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = [UIColor themeCellBackgroundColor];
    self.borderLayer = [CALayer layer];
    self.borderLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
    [self.contentView.layer addSublayer:self.borderLayer];
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
