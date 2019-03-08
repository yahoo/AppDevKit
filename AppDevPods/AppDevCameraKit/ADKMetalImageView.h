//
//  ADKMetalImageView.h
//  AppDevKit
//
//  Created by  Chih Feng Sung on 12/11/18.
//  Copyright © 2018 Yahoo. All rights reserved.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADKMetalImageViewContentMode) {
    ADKMetalImageViewContentModeScaleToFill = 0,
    ADKMetalImageViewContentModeScaleAspectFit,
    ADKMetalImageViewContentModeScaleAspectFill,
    ADKMetalImageViewContentModeCenter,
    ADKMetalImageViewContentModeTop,
    ADKMetalImageViewContentModeBottom,
    ADKMetalImageViewContentModeLeft,
    ADKMetalImageViewContentModeRight,
    ADKMetalImageViewContentModeTopLeft,
    ADKMetalImageViewContentModeTopRight,
    ADKMetalImageViewContentModeBottomLeft,
    ADKMetalImageViewContentModeBottomRight
};

@interface ADKMetalImageView : MTKView

/**
 * @brief An image that you want to be rendered on the screen by Metal kit. It must be a core image and use it in main thread.
 */
@property (strong, nonatomic) CIImage *image;

/**
 * @brief A flag used to determine how a image lays out its content when its bounds change. If you want to scale the image to fit or fill the space while maintaining the image’s original aspect ratio. It would help you do that easily.
 */
@property (assign, nonatomic) ADKMetalImageViewContentMode contentMode;

@end

