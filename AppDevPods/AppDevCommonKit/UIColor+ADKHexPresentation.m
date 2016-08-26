//
//  UIColor+ADKHexPresentation.m
//  AppDevKit
//
//  Created by Wei-Hon (Plasma) Chen on 8/13/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "UIColor+ADKHexPresentation.h"

@implementation UIColor (ADKHexPresentation)

+ (UIColor *)ADKColorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [[UIColor alloc] ADKInitWithHexRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)ADKInitWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [[UIColor alloc] initWithRed:red / (0xff*1.0f) green:green / (0xff*1.0f) blue:blue / (0xff*1.0f) alpha:alpha];
}

+ (UIColor *)ADKColorWithHexString:(NSString *)hexString
{
    return [[UIColor alloc] ADKInitWithHexString:hexString];
}

+ (UIColor *)ADKColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    return [[UIColor ADKColorWithHexString:hexString] colorWithAlphaComponent:alpha];
}

- (UIColor *)ADKInitWithHexString:(NSString *)hexString
{
    NSUInteger rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ( [hexString hasPrefix:@"#"] ) {
        [scanner setScanLocation:1];
    }
    [scanner scanHexInt:(unsigned int *)&rgbValue];
    
    return [self ADKInitWithHexNumber:rgbValue];
}

+ (UIColor *)ADKColorWithHexNumber:(NSUInteger)hexNumber
{
    return [[UIColor alloc] ADKInitWithHexNumber:hexNumber];
}

- (UIColor *)ADKInitWithHexNumber:(NSUInteger)hexNumber
{
    CGFloat red   = ((hexNumber & 0xff0000) >> 16) / 255.0f;
    CGFloat green = ((hexNumber & 0x00ff00) >>  8) / 255.0f;
    CGFloat blue  = ((hexNumber & 0x0000ff)      ) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (UIColor *)ADKColorShiftBySaturation:(CGFloat)shiftValue
{
    CGFloat hue, saturation, brightness, alpha;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    saturation += shiftValue;
    saturation = MIN(saturation, 1.0f);
    saturation = MAX(saturation, 0.0f);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

- (UIColor *)ADKColorShiftByBrightness:(CGFloat)shiftValue
{
    CGFloat hue, saturation, brightness, alpha;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    brightness += shiftValue;
    brightness = MIN(brightness, 1.0f);
    brightness = MAX(brightness, 0.0f);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

// reference to http://stackoverflow.com/questions/970475/how-to-compare-uicolors
- (BOOL)ADKIsEqualToColor:(UIColor *)anotherColor
{
    if (self == anotherColor)
        return YES;
    
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color)
    {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome)
        {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        }
        else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    anotherColor = convertColorToRGBSpace(anotherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:anotherColor];
}

- (NSString *)ADKHexString
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);

    CGFloat red = components[0];
    CGFloat greeen = components[1];
    CGFloat blue = components[2];

    return [NSString stringWithFormat:@"%02lX%02lX%02lX", lroundf(red * 255), lroundf(greeen * 255), lroundf(blue * 255)];
}

@end
