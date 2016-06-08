//
//  ControllerTestUtils.m
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/12/9.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Kiwi/Kiwi.h>
#import "ControllerTestUtils.h"
#import "AppDelegate.h"

@implementation ControllerTestUtils

+ (NSArray *)createUINavigationControllerArrayWithCapacity:(NSInteger)capacity
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < capacity; i++) {
        UINavigationController *navigationController = [[UINavigationController alloc] init];
        UIViewController *viewController = [[UIViewController alloc] init];
        [navigationController setViewControllers:@[viewController] animated:NO];
        [array addObject:navigationController];
    }
    return array;
}

@end
