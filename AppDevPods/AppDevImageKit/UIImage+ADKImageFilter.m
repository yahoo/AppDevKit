//
//  UIImage+ImageFilter.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 9/10/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#define GETTHEME_DEFAULT_RESIZE_VAL 64

#import "UIImage+ADKImageFilter.h"
@import Accelerate;


@implementation UIImage (ADKImageFilter)

+ (UIImage *)ADKCaptureView:(UIView *)view
{
    return [self ADKCaptureView:view withFrame:view.bounds];
}

+ (UIImage *)ADKCaptureView:(UIView *)view withFrame:(CGRect)rect
{
    // ref:http://stackoverflow.com/questions/20558033/ios-7-taking-screenshot-of-part-of-a-uiview
    CGRect cropRect = view.bounds;
    cropRect.origin.x = -CGRectGetMinX(rect);
    cropRect.origin.y = -CGRectGetMinY(rect);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:cropRect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)ADKResizeByMaxLength:(NSInteger)maxLength
{
    CGFloat ratio = self.size.height / self.size.width;
    CGSize newSize;
    if (self.size.width >= self.size.height) {
        newSize = CGSizeMake(maxLength, maxLength * ratio);
    } else {
        newSize = CGSizeMake(maxLength / ratio, maxLength);
    }

    return [self ADKScaleToSize:newSize];
}

- (UIImage *)ADKScaleToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)ADKCropSize:(CGSize)cropSize
{
    return [self ADKCropRect:CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height)];
}

- (UIImage *)ADKCropRect:(CGRect)cropRect
{
    UIGraphicsBeginImageContextWithOptions(cropRect.size, NO, self.scale);
    [self drawAtPoint:CGPointMake(-cropRect.origin.x, -cropRect.origin.y)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)ADKGaussianBlurWithRadius:(NSInteger)blurRadius
{
    CGRect imageDrawRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, imageDrawRect, self.CGImage);

    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

    CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
    uint32_t radius = floorl(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
    if (radius % 2 != 1) {
        radius += 1;
    }
    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);

    CGContextDrawImage(outputContext, imageDrawRect, self.CGImage);

    CGContextSaveGState(outputContext);
    CGContextDrawImage(outputContext, imageDrawRect, finalImage.CGImage);
    CGContextRestoreGState(outputContext);

    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
}


/// mask  UIImage with UIColor
- (UIImage *)ADKMaskImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}

- (UIImage *)ADKOverlayWithTexture:(UIImage *)textureImage
{
    UIImage *result = [self ADKOverlayWithTexture:textureImage transparent:0.7f];

    return result;
}

- (UIImage *)ADKOverlayWithTexture:(UIImage *)textureImage transparent:(CGFloat)transparent
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);

    [self drawInRect:rect];
    CGFloat aspectRatio = textureImage.size.height / textureImage.size.width;
    [textureImage drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.width * aspectRatio) blendMode:kCGBlendModeNormal alpha:transparent];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}

- (UIImage *)ADKBlackAndWhiteImage
{
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width * self.scale, self.size.height * self.scale, 8, self.size.width * self.scale, colorSapce, kCGBitmapByteOrderDefault);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, self.size.width * self.scale, self.size.height * self.scale), self.CGImage);

    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);

    UIImage *resultImage = [UIImage imageWithCGImage:bwImage];
    CGImageRelease(bwImage);

    return resultImage;
}

@end
