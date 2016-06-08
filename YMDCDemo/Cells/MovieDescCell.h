//
//  MovieDescCell.h
//  AppDevKit
//
//  Created by Jeff Lin on 3/26/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "AppDevKit.h"

extern NSString * const MovieDescCellIdentifier;

@interface MovieDescCell : ADKCollectionViewDynamicSizeCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *expandButton;

@end
