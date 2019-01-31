//
//  ADKMultiGradientView.h
//  AppDevKit
//
//  Created by  Chih Feng Sung on 1/29/19.
//  Copyright © 2019 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADKGradientEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADKMultiGradientView : UIView

/**
 * @brief The colors that use to describe gradient colors. It has to contain UIColor elements.
 *
 */
@property (nonatomic, strong) NSArray <UIColor *> *gradientColors;

/**
 * @brief The locations that use to locate gradient color's position. It musts contain NSnumber with CGFloat elements and each value needs from 0.0f to 1.0f.
 *
 */
@property (nonatomic, strong) NSArray <NSNumber *> *gradientLocations;

/**
 * @brief Decide how to paint gradient on this view.
 *
 */
@property (nonatomic, assign) ADKBlendsType blendsType;

/**
 * @brief Asking current view needs to redraw itself. if you change any setting after initialized, you might need to redraw view to display the newest setting.
 *
 */
- (void)redrawView;

@end

NS_ASSUME_NONNULL_END
