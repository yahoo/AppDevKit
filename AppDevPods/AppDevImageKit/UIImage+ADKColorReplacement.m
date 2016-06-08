//
//  UIImage+ADKColorReplacement.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 8/27/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "UIImage+ADKColorReplacement.h"
#import "UIColor+ADKHexPresentation.h"

typedef NS_ENUM(NSUInteger, ADKColorReplaceMode) {
    ADKColorReplaceModeReplace = 0,
    ADKColorReplaceModeTint,
    ADKColorReplaceModeInstead,
};

static NSCache *s_imageCache;

@implementation UIImage (ADKColorReplacement)

+ (void)load
{
    s_imageCache = [[NSCache alloc] init];
}

+ (UIImage *)ADKImage:(UIImage *)image tintColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(contextRef, 0.0f, image.size.height);
    CGContextScaleCTM(contextRef, 1.0f,  -1.0f);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(contextRef, drawRect, image.CGImage);
    CGContextSetBlendMode(contextRef, kCGBlendModeMultiply);
    CGContextClipToMask(contextRef, drawRect, image.CGImage);
    CGContextAddRect(contextRef, drawRect);
    CGContextDrawPath(contextRef, kCGPathFill);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (UIImage *)ADKImage:(UIImage *)image replaceColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(contextRef, 0.0f, image.size.height);
    CGContextScaleCTM(contextRef, 1.0f,  -1.0f);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(contextRef, drawRect, image.CGImage);
    CGContextClipToMask(contextRef, drawRect, image.CGImage);
    CGContextAddRect(contextRef, drawRect);
    CGContextDrawPath(contextRef, kCGPathFill);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (UIImage *)ADKImage:(UIImage *)image replaceColor:(UIColor *)fromColor withColor:(UIColor *)toColor
{
    CGImageRef imageRef = image.CGImage;

    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;

    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));

    CGContextRef contextRef = CGBitmapContextCreate(rawData, width, height,
                                                    bitsPerComponent, bytesPerRow, colorSpace,
                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(contextRef, CGRectMake(0.0f, 0.0f, width, height), imageRef);

    CGColorRef fromColorRef = fromColor.CGColor;
    const CGFloat *fromColorComponents = CGColorGetComponents(fromColorRef);
    float fromColorRed = fromColorComponents[0];
    float fromColorGreen = fromColorComponents[1];
    float fromColorBlue = fromColorComponents[2];
    float fromColorAlpha = fromColorComponents[3];
    fromColorRed = fromColorRed * 255.0f;
    fromColorGreen = fromColorGreen * 255.0f;
    fromColorBlue = fromColorBlue * 255.0f;
    fromColorAlpha = fromColorAlpha * 255.0f;

    CGColorRef toColorRef = toColor.CGColor;
    const CGFloat *toColorComponents = CGColorGetComponents(toColorRef);
    float toColorRed = toColorComponents[0];
    float toColorGreen = toColorComponents[1];
    float toColorBlue = toColorComponents[2];
    float toColorAlpha = toColorComponents[3];
    toColorRed = toColorRed * 255.0f;
    toColorGreen = toColorGreen * 255.0f;
    toColorBlue = toColorBlue * 255.0f;
    toColorAlpha = toColorAlpha * 255.0f;

    int byteIndex = 0;

    while (byteIndex < bitmapByteCount) {
        float currentRed = rawData[byteIndex];
        float currentGreen = rawData[byteIndex + 1];
        float currentBlue = rawData[byteIndex + 2];
        float currentAlpha = rawData[byteIndex + 3];

        if (currentRed == fromColorRed && currentGreen == fromColorGreen && currentBlue == fromColorBlue && currentAlpha == fromColorAlpha) {
            rawData[byteIndex] = toColorRed;
            rawData[byteIndex + 1] = toColorGreen;
            rawData[byteIndex + 2] = toColorBlue;
            rawData[byteIndex + 3] = toColorAlpha;
        }

        byteIndex += 4;
    }

    CGImageRef imageResultRef = CGBitmapContextCreateImage(contextRef);
    UIImage *resultImage = [UIImage imageWithCGImage:imageResultRef];

    CGImageRelease(imageResultRef);
    CGContextRelease(contextRef);
    free(rawData);

    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (UIImage *)ADKImageNamed:(NSString *)name tintColor:(UIColor *)color
{
    NSString *cacheKeyString = [UIImage cacheKeyStringWithImageNamed:name
                                                    colorReplaceMode:ADKColorReplaceModeTint
                                                               color:color];
    UIImage *resultImage = [s_imageCache objectForKey:cacheKeyString];
    if (resultImage) {
        return resultImage;
    }

    UIImage *image = [UIImage imageNamed:name];
    resultImage = [UIImage ADKImage:image tintColor:color];
    if (resultImage) {
        [s_imageCache setObject:resultImage forKey:cacheKeyString];
    }

    return resultImage;
}

+ (UIImage *)ADKImageNamed:(NSString *)name replaceColor:(UIColor *)color
{
    NSString *cacheKeyString = [UIImage cacheKeyStringWithImageNamed:name
                                                    colorReplaceMode:ADKColorReplaceModeReplace
                                                               color:color];
    UIImage *resultImage = [s_imageCache objectForKey:cacheKeyString];
    if (resultImage) {
        return resultImage;
    }

    UIImage *image = [UIImage imageNamed:name];
    resultImage = [UIImage ADKImage:image replaceColor:color];
    if (resultImage) {
        [s_imageCache setObject:resultImage forKey:cacheKeyString];
    }

    return resultImage;
}

+ (UIImage *)ADKImageNamed:(NSString *)name replaceColor:(UIColor *)fromColor withColor:(UIColor *)toColor
{
    NSString *cacheKeyString = [UIImage cacheKeyStringWithImageNamed:name
                                                    colorReplaceMode:ADKColorReplaceModeInstead
                                                           fromColor:fromColor
                                                             toColor:toColor];
    UIImage *resultImage = [s_imageCache objectForKey:cacheKeyString];
    if (resultImage) {
        return resultImage;
    }

    UIImage *image = [UIImage imageNamed:name];
    resultImage = [UIImage ADKImage:image replaceColor:fromColor withColor:toColor];
    if (resultImage) {
        [s_imageCache setObject:resultImage forKey:cacheKeyString];
    }

    return resultImage;
}

+ (UIImage *)ADKImageWithColor:(UIColor *)color size:(CGSize)size;
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (contextRef) {
        CGContextSetFillColorWithColor(contextRef, [color CGColor]);
        CGContextFillRect(contextRef, rect);
    }

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

+ (UIImage *)ADKImage:(UIImage *)image colorWithAlphaComponent:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contextRef, 0.0f, image.size.height);
    CGContextScaleCTM(contextRef, 1.0f, -1.0f);
    CGContextSetAlpha(contextRef, alpha);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(contextRef, drawRect, image.CGImage);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (NSString *)cacheKeyStringWithImageNamed:(NSString *)name colorReplaceMode:(ADKColorReplaceMode)mode color:(UIColor *)color
{
    NSString *hexString = [color ADKHexString];
    NSString *modeString = (mode == ADKColorReplaceModeReplace) ? @"replace" : @"tint";
    NSString *keyString = [NSString stringWithFormat:@"%@-%@-%@", name, modeString, hexString];

    return keyString;
}

+ (NSString *)cacheKeyStringWithImageNamed:(NSString *)name colorReplaceMode:(ADKColorReplaceMode)mode fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    NSString *fromHexString = [fromColor ADKHexString];
    NSString *toHexString = [toColor ADKHexString];
    NSString *modeString = (mode == ADKColorReplaceModeReplace) ? @"replace" : @"tint";
    NSString *keyString = [NSString stringWithFormat:@"%@-%@-%@:%@", name, modeString, fromHexString, toHexString];

    return keyString;
}

@end
