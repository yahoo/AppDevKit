//
//  UIImage+ADKDrawingTemplate.h
//  AppDevKit
//
//  Created by Jeff Lin on 6/3/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

@interface UIImage (ADKDrawingTemplate)

/**
 * @brief Scale image to target size without loss quality. Only support PDF file currently.
 *
 * @param imagePath file name for image in bundle, Only support PDF file currently.
 *
 * @param targetSize target size for generate image
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)ADKLosslessImageFromPDFPath:(NSString *)imagePath size:(CGSize)targetSize;

@end
