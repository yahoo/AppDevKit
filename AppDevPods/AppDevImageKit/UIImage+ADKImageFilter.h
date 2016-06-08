//
//  UIImage+ADKImageFilter.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 9/10/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

@interface UIImage (ADKImageFilter)

/**
 * @brief Capture view's screenshot.
 *
 * @param view The view need to capture.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKCaptureView:(UIView *)view;

/**
 *  @brief Capture view and crop it with target rect as an image
 *
 *  @param view The view will be captured.
 *  @param rect Rect in view will be cropped.
 *
 *  @return Snapshot image of cropped view
 */
+ (UIImage *)ADKCaptureView:(UIView *)view withFrame:(CGRect)rect;

/**
 * @brief Resize image's size to max length in proportion.
 *
 * @param maxLength The value of max image length with NSInteger. The unit is pt.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKResizeByMaxLength:(NSInteger)maxLength;

/**
 * @brief Resize image's size to specific size.
 *
 * @param newSize The size of expected new image.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKScaleToSize:(CGSize)newSize;

/**
 * @brief Crop image's to assign size.
 *
 * @param cropSize The value of crop size with CGSize.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKCropSize:(CGSize)cropSize;

/**
 * @brief Crop image's to assign rectangle.
 *
 * @param cropRect The value of crop rectangle with CGRect.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKCropRect:(CGRect)cropRect;

/**
 * @brief Apply gaussian blur effect on image.
 *
 * @param radius The value of NSInteger.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKGaussianBlurWithRadius:(NSInteger)radius;

/**
 * @brief Overlay color on image.
 *
 * @param color The value of UIColor.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKMaskImageWithColor:(UIColor *)color;

/**
 * @brief Overlay one texture with 70% tranparent on image.
 *
 * @param textureImage The UIImage of overlay texture.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKOverlayWithTexture:(UIImage *)textureImage;

/**
 * @brief Overlay one texture on image.
 *
 * @param textureImage The UIImage of overlay texture.
 * @param transparent The transparent value of overlay texture. (0.0f ~ 1.0f)
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKOverlayWithTexture:(UIImage *)textureImage transparent:(CGFloat)transparent;

/**
 * @brief Apply black & white effect on image.
 *
 * @return The instance of result UIImage.
 */
- (UIImage *)ADKBlackAndWhiteImage;

@end
