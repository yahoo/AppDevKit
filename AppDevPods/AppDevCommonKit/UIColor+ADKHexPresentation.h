//
//  UIColor+ADKHexPresentation.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 8/13/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

@interface UIColor (ADKHexPresentation)

/**
 * @brief Create a color by hex format.
 *
 * @param red  Red channel value with hex NSUInteger.
 * @param green Green channel value with hex NSUInteger.
 * @param blue Blue channel value with hex NSUInteger.
 * @param alpha Alpha channel value with hex.
 *
 * @return The instance of UIColor.
 */
+ (UIColor *)ADKColorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha;

/**
 * @brief Create a color by hex format.
 *
 * @param red  Red channel value with hex NSUInteger.
 * @param green Green channel value with hex NSUInteger.
 * @param blue Blue channel value with hex NSUInteger.
 * @param alpha Alpha channel value with hex.
 *
 * @return The instance of UIColor.
 */
- (UIColor *)ADKInitWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha;

/**
 * @brief Create a color by hex string.
 *
 * @param hexstring The value of hex NSString.
 *
 * @return The instance of UIColor.
 */
+ (UIColor *)ADKColorWithHexString:(NSString *)hexString;

/**
 * @brief Create a color by hex string and alpha.
 *
 * @param hexstring The value of hex NSString.
 * @param alpha The value of alpha NSString.
 *
 * @return The instance of UIColor.
 */
+ (UIColor *)ADKColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * @brief Create a color by hex string.
 *
 * @param hexstring The value of hex NSString.
 *
 * @return The instance of UIColor.
 */
- (UIColor *)ADKInitWithHexString:(NSString *)hexString;

/**
 * @brief Create a color by hex number.
 *
 * @param hexNumber The value of hex NSUInteger.
 *
 * @return The instance of UIColor.
 */
+ (UIColor *)ADKColorWithHexNumber:(NSUInteger)hexNumber;

/**
 * @brief Create a color by hex number.
 *
 * @param hexNumber The value of hex NSUInteger.
 *
 * @return The instance of UIColor.
 */
- (UIColor *)ADKInitWithHexNumber:(NSUInteger)hexNumber;

/**
 * @brief Shift saturation from exist color to create a new color.
 *
 * @param shiftValue The value of saturation needs to shift. 
 * Shift value can include positive or negative float and saturation must between 0.0f and 1.0f.
 *
 * @return The instance of UIColor.
 */
- (UIColor *)ADKColorShiftBySaturation:(CGFloat)shiftValue;

/**
 * @brief Shift brightness from exist color to create a new color. Shift value should be float.
 *
 * @param shiftValue The value of brightness needs to shift.
 * Shift value can include positive or negative float and brightness must between 0.0f and 1.0f.
 *
 * @return The instance of UIColor.
 */
- (UIColor *)ADKColorShiftByBrightness:(CGFloat)shiftValue;

/**
 * @brief comparing colors that are in different models/spaces
 *
 * @param anotherColor The UIColor which is comparing
 *
 * @return YES if they are the same one
 */
- (BOOL)ADKIsEqualToColor:(UIColor *)anotherColor;

/**
 * @brief Generate a HEX string for UIColor .
 *
 * @return A NSString with HEX format.
 */
- (NSString *)ADKHexString;

@end
