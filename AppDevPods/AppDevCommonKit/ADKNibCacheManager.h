//
//  ADKNibCacheManager.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/8/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ADKNibCacheManager : NSObject

/**
 * @brief Geting a shared instance of ADKNibCacheManager.
 *
 * @return Instance of ADKNibCacheManager.
 */
+ (instancetype)sharedInstance;

/**
 * @brief This is a method for get singleton instance from Nib name.
 *
 * @param nibName input nib name for identifier, should be in string.
 *
 * @return instance of the cached class.
 */
- (instancetype)instanceForNibNamed:(NSString *)nibName;

/**
 * @brief This is a method for get singleton instance from class file.
 *
 * @param className input class name for identifier, should be in string.
 *
 * @return instance of the cached class.
 */
- (instancetype)instanceForClassNamed:(NSString *)className;

@end
