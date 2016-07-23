//
//  UIImage+ADKColorReplacement.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 8/27/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//
//  REMIND: + (UIImage *)image:replaceColor:withColor: not support [UIColor whiteColor] and [UIColor blackColor] now. I will fix it later.
//          If you want assisn [UIColor whiteColor], please use [UIColor colorWithHexString:@"ffffff"] to represent [UIColor whiteColor].
//

#import <UIKit/UIKit.h>

@interface UIImage (ADKColorReplacement)

/**
 * @brief Mix specific color with image instance.
 *
 * @param image The image instace want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImage:(UIImage *)image tintColor:(UIColor *)color;

/**
 * @brief Replace opacity pixel with specific color in image instance.
 *
 * @param image The image instace want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImage:(UIImage *)image replaceColor:(UIColor *)color;

/**
 * @brief Replace specific color with another color in image instance.
 *
 * @param image The image instace want to process.
 * @param fromColor The original color need be replaced.
 * @param toColor The color will replace original color.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImage:(UIImage *)image replaceColor:(UIColor *)fromColor withColor:(UIColor *)toColor;

/**
 * @brief Mix specific color with image name.
 *
 * @param name The image name want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImageNamed:(NSString *)name tintColor:(UIColor *)color;

/**
 * @brief Replace opacity pixel with specific color in image name.
 *
 * @param name The image name want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImageNamed:(NSString *)name replaceColor:(UIColor *)color;

/**
 * @brief Replace specific color with another color in image name.
 *
 * @param name The image name want to process.
 * @param fromColor The original color need be replaced.
 * @param toColor The color will replace original color.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImageNamed:(NSString *)name replaceColor:(UIColor *)fromColor withColor:(UIColor *)toColor;

/**
 * @brief Overlap specific color on image instance.
 *
 * @param color The color will affect image result.
 * @param size The expected final result image size.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * @brief Change image instance's alpha value.
 *
 * @param image The image instace want to process.
 * @param alpha The expected alpha value for result image.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKImage:(UIImage *)image colorWithAlphaComponent:(CGFloat)alpha;

@end
