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
    return [self initWithRed:red / (0xff*1.0f) green:green / (0xff*1.0f) blue:blue / (0xff*1.0f) alpha:alpha];
}

+ (UIColor *)ADKColorWithHexString:(NSString *)hexString
{
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        return [self ADKColorWithRGBHexString:[hexString substringFromIndex:2]];
    } else {
        return [self ADKColorWithRGBHexString:hexString];
    }
}

+ (UIColor *)ADKColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    return [[UIColor ADKColorWithHexString:hexString] colorWithAlphaComponent:alpha];
}

- (UIColor *)ADKInitWithHexString:(NSString *)hexString
{
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        return [self.class ADKColorWithRGBHexString:[hexString substringFromIndex:2]];
    } else {
        return [self.class ADKColorWithRGBHexString:hexString];
    }
}

+ (UIColor *)ADKColorWithRGBHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self ADKColorComponentFrom:colorString start:0 length:1];
            green = [self ADKColorComponentFrom:colorString start:1 length:1];
            blue  = [self ADKColorComponentFrom:colorString start:2 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self ADKColorComponentFrom:colorString start:0 length:2];
            green = [self ADKColorComponentFrom:colorString start:2 length:2];
            blue  = [self ADKColorComponentFrom:colorString start:4 length:2];
            break;
        default:
            return [UIColor whiteColor];
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

// Ref: https://gist.github.com/codingrhythm/4751825
+ (UIColor *)ADKColorWithARGBHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self ADKColorComponentFrom:colorString start:0 length:1];
            green = [self ADKColorComponentFrom:colorString start:1 length:1];
            blue  = [self ADKColorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self ADKColorComponentFrom:colorString start:0 length:1];
            red   = [self ADKColorComponentFrom:colorString start:1 length:1];
            green = [self ADKColorComponentFrom:colorString start:2 length:1];
            blue  = [self ADKColorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self ADKColorComponentFrom:colorString start:0 length:2];
            green = [self ADKColorComponentFrom:colorString start:2 length:2];
            blue  = [self ADKColorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self ADKColorComponentFrom:colorString start:0 length:2];
            red   = [self ADKColorComponentFrom:colorString start:2 length:2];
            green = [self ADKColorComponentFrom:colorString start:4 length:2];
            blue  = [self ADKColorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return [UIColor whiteColor];
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (UIColor *)ADKColorWithRGBAHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            red   = [self ADKColorComponentFrom:colorString start:0 length:1];
            green = [self ADKColorComponentFrom:colorString start:1 length:1];
            blue  = [self ADKColorComponentFrom:colorString start:2 length:1];
            alpha = 1.0f;
            break;
        case 4: // #RGBA
            red   = [self ADKColorComponentFrom:colorString start:0 length:1];
            green = [self ADKColorComponentFrom:colorString start:1 length:1];
            blue  = [self ADKColorComponentFrom:colorString start:2 length:1];
            alpha = [self ADKColorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            red   = [self ADKColorComponentFrom:colorString start:0 length:2];
            green = [self ADKColorComponentFrom:colorString start:2 length:2];
            blue  = [self ADKColorComponentFrom:colorString start:4 length:2];
            alpha = 1.0f;
            break;
        case 8: // #RRGGBBAA
            red   = [self ADKColorComponentFrom:colorString start:0 length:2];
            green = [self ADKColorComponentFrom:colorString start:2 length:2];
            blue  = [self ADKColorComponentFrom:colorString start:4 length:2];
            alpha = [self ADKColorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return [UIColor whiteColor];
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
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

+ (CGFloat)ADKColorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
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

    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateWithName(kCGColorSpaceExtendedSRGB);

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
