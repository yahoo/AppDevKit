//
//  ADKNibCacheManager.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/8/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKNibCacheManager.h"


@interface ADKNibCacheManager ()

@property (nonatomic, strong) NSCache *nibInstanceCache;

@end


@implementation ADKNibCacheManager

+ (instancetype)sharedInstance
{
    static ADKNibCacheManager *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[ADKNibCacheManager alloc] init];
            instance.nibInstanceCache = [[NSCache alloc] init];
        }
    });

    return instance;
}

- (instancetype)instanceForNibNamed:(NSString *)nibName
{
    id classInstance = nil;
    NSString *nibNameKey = [nibName stringByAppendingPathComponent:@"nib"];
    if ([self.nibInstanceCache objectForKey:nibNameKey]) {
        classInstance = [self.nibInstanceCache objectForKey:nibNameKey];
    } else {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        __block UIView *blockClassInstance = nil;
        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                blockClassInstance = obj;
                *stop = YES;
            }
        }];
        classInstance = blockClassInstance;
        [self.nibInstanceCache setObject:classInstance forKey:nibNameKey];
    }

    return classInstance;
}

- (instancetype)instanceForClassNamed:(NSString *)className
{
    id classInstance = nil;
    NSString *classNameKey = [className stringByAppendingPathComponent:@"class"];
    if ([self.nibInstanceCache objectForKey:classNameKey]) {
        classInstance = [self.nibInstanceCache objectForKey:classNameKey];
    } else {
        Class class = [[NSBundle mainBundle] classNamed:className];
        classInstance = [[class alloc] init];
        [self.nibInstanceCache setObject:classInstance forKey:classNameKey];
    }

    return classInstance;
}



@end
