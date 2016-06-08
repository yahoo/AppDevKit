//
//  ADKViewExclusiveTouch.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 10/8/14.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>

@interface ADKViewExclusiveTouch : NSObject

/**
 * @brief Geting a shared instance of ADKViewExclusiveTouch.
 *
 * @return Instance of ADKViewExclusiveTouch.
 */
+ (instancetype)sharedInstance;

/**
 * @brief Setting specific views for exclsive touching.
 *
 * @param targetView Assiging a target view and subviews that you want to prevent touch multiple views at same time.
 *
 * @return Did it correct for running.
 */
- (BOOL)exclusiveTouchinView:(id)targetView;

@end
