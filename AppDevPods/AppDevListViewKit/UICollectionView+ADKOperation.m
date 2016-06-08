//
//  UICollectionView+ADKOperation.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 11/28/14.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "UICollectionView+ADKOperation.h"

@implementation UICollectionView (ADKOperation)

- (void)ADKForceStopScrolling
{
    CGPoint offset = self.contentOffset;
    (self.contentOffset.y > 0) ? offset.y-- : offset.y++;
    [self setContentOffset:offset animated:NO];
}

@end
