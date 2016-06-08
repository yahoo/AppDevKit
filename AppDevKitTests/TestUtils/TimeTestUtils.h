//
//  TimeTestUtils.h
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/11/20.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>

@interface TimeTestUtils : NSObject

+ (void)setTaipeiTimezone;
+ (void)mockTimeIntervalSinceNow:(NSString*)timeStampText;
+ (void)mockTimeIntervalSince1970:(NSString*)timeStampText;

@end
