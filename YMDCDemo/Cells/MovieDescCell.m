//
//  MovieDescCell.m
//  AppDevKit
//
//  Created by Jeff Lin on 3/26/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "MovieDescCell.h"

NSString * const MovieDescCellIdentifier = @"MovieDescCell";

@interface MovieDescCell ()

@property (weak, nonatomic) IBOutlet ADKGradientView *shadowView;

@end

@implementation MovieDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    
    self.shadowView.blensType = ADKBlensTypeFromTopToBottom;
    self.shadowView.beginColor = [UIColor clearColor];
    self.shadowView.endColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    
    [self.expandButton setImage:[UIImage ADKImage:[UIImage imageNamed:@"Icon-Arrow-Down"] replaceColor:[UIColor grayColor]] forState:UIControlStateNormal];
}

- (IBAction)expandButtonTap:(UIButton *)sender {
    // Do something...
}

@end
