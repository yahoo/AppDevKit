//
//  ADKOpenGLImageView.h
//  AppDevKit
//
//  Created by  Chih Feng Sung on 9/11/17.
//  Copyright © 2017, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.

#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADKOpenGLImageViewContentMode) {
    ADKOpenGLImageViewContentModeScaleToFill = 0,
    ADKOpenGLImageViewContentModeScaleAspectFit,
    ADKOpenGLImageViewContentModeScaleAspectFill,
    ADKOpenGLImageViewContentModeCenter,
    ADKOpenGLImageViewContentModeTop,
    ADKOpenGLImageViewContentModeBottom,
    ADKOpenGLImageViewContentModeLeft,
    ADKOpenGLImageViewContentModeRight,
    ADKOpenGLImageViewContentModeTopLeft,
    ADKOpenGLImageViewContentModeTopRight,
    ADKOpenGLImageViewContentModeBottomLeft,
    ADKOpenGLImageViewContentModeBottomRight
};

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface ADKOpenGLImageView : GLKView

/**
 * @brief An image that you want to be rendered on the screen by OpenGL ES2. It must be a core image and use it in main thread.
 */
@property (strong, nonatomic) CIImage *image;

/**
 * @brief A flag used to determine how a image lays out its content when its bounds change. If you want to scale the image to fit or fill the space while maintaining the image’s original aspect ratio. It would help you do that easily.
 */
@property (assign, nonatomic) ADKOpenGLImageViewContentMode contentMode;

@end

#pragma clang diagnostic pop
