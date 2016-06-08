//
//  ADKNibSizeCalculator.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 10/21/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ADKNibSizeCalculator.h"

@interface ADKNibSizeCalculator ()

@property (nonatomic, strong) NSCache *nibSizeCache;

@end

@implementation ADKNibSizeCalculator

+ (instancetype)sharedInstance
{
    static ADKNibSizeCalculator *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[ADKNibSizeCalculator alloc] init];
            instance.nibSizeCache = [[NSCache alloc] init];
        }
    });

    return instance;
}


- (CGSize)sizeForNibNamed:(NSString *)nibName
{
    return  [[ADKNibSizeCalculator sharedInstance] sizeForNibNamed:nibName withStyle:ADKNibDefaultScaling];
}


- (CGSize)sizeForNibNamed:(NSString *)nibName withStyle:(ADKNibSizeStyle)style
{
    return [self sizeForNibNamed:nibName withStyle:style fitSize:ADKScreenSize()];
}

- (CGSize)sizeForNibNamed:(NSString *)nibName withStyle:(ADKNibSizeStyle)style fitSize:(CGSize)containerSize
{
    CGSize nibSize = ADKCGSizeZeroHeight();
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    NSString *nibwithStyle = [NSString stringWithFormat:@"%@_%lu_%lu_%@", nibName, (unsigned long)deviceOrientation, (unsigned long)style, NSStringFromCGSize(containerSize)];
    if ([self.nibSizeCache objectForKey:nibwithStyle] && style != ADKNibUncachedCustomCalculation) {
        NSString *sizeString = [self.nibSizeCache objectForKey:nibwithStyle];
        nibSize = CGSizeFromString(sizeString);
    } else {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        __block UIView *blockClassInstance = nil;
        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                blockClassInstance = obj;
                *stop = YES;
            }
        }];
        UIView *nibView = blockClassInstance;
        if (nibView != nil) {
            nibSize = nibView.bounds.size;
            CGSize targetSize = containerSize;
            CGFloat ratio = targetSize.width / nibSize.width;
            CGFloat ratioNibHeight = ratio * nibSize.height;
            CGFloat heightAdjustment = (ratioNibHeight - containerSize.width) / ratio;

            switch (style) {
                case ADKNibOriginalSize:
                    break;
                case ADKNibBottomFixedScaling:
                    nibSize.width = ratio * nibSize.width;
                    nibSize.height = targetSize.width + heightAdjustment;
                    break;
                case ADKNibFixedHeightScaling:
                    nibSize.width = ratio * nibSize.width;
                    nibSize.height = nibSize.height;
                    break;
                case ADKNibCustomCalculation:
                case ADKNibUncachedCustomCalculation: {
                    if ([nibView conformsToProtocol:@protocol(ADKNibSizeCustomCalculationProtocol)] && [nibView respondsToSelector:@selector(sizeThatFitsWidth:)]) {
                        nibSize = [(id <ADKNibSizeCustomCalculationProtocol>)nibView sizeThatFitsWidth:targetSize.width];
                        break;
                    }

                    // NOTE: if NibCustomCalculation cannot be done, then fallback to NibDefaultScaling, so no break here.
                }
                case ADKNibDefaultScaling:
                default:
                    nibSize.width = ratio * nibSize.width;
                    nibSize.height = ratio * nibSize.height;
                    break;
            }
            nibSize.width = MIN(nibSize.width, targetSize.width);
            nibSize.height = MIN(nibSize.height, targetSize.height);
            [self.nibSizeCache setObject:NSStringFromCGSize(nibSize) forKey:nibwithStyle];
        }
    }
    return nibSize;
}

@end
