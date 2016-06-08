//
//  YMDCDemoImageCell.h
//  AppDevKit
//
//  Created by Jeff Lin on 3/24/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

extern NSString * const YMDCDemoImageCellIdentifier;

@interface YMDCDemoImageCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end
