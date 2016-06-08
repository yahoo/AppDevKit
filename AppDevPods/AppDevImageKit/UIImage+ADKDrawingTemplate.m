//
//  UIImage+ADKDrawingTemplate.m
//  AppDevKit
//
//  Created by Jeff Lin on 6/3/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "UIImage+ADKDrawingTemplate.h"

@implementation UIImage (ADKDrawingTemplate)

+ (UIImage *)ADKLosslessImageFromPDFPath:(NSString *)imagePath size:(CGSize)targetSize
{
    // Read pdf
    NSURL *url = [NSURL fileURLWithPath:imagePath];
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((CFURLRef)url);
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdfRef, 1);
    
    // Get origin pdf size
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
    CGSize size = pageRect.size;
    
    // Create context
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Transform to target size
    CGAffineTransform pdfToPageTransform = CGAffineTransformMakeScale(targetSize.width / size.width, targetSize.height / size.height);
    CGContextConcatCTM(ctx, pdfToPageTransform);
    CGContextDrawPDFPage(ctx, pageRef);
    
    // Release
    CGPDFDocumentRelease(pdfRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
