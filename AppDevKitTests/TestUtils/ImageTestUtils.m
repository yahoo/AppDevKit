//
//  ImageTestUtils.m
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/11/21.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ImageTestUtils.h"

@implementation ImageTestUtils

+ (UIImage *)readImageNamed:(NSString*)imageName
{
    return [ImageTestUtils readImageNamed:imageName scale:1];
}

+ (UIImage *)readImageNamed:(NSString *)imageName scale:(CGFloat)scale
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:imageName.stringByDeletingPathExtension ofType:imageName.pathExtension];
    UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfFile:imagePath] scale:scale];
    return image;
}

+ (BOOL)compareImage:(UIImage *)testImage toImage:(UIImage *)expectedImage
{
    CGSize testImageSize = CGSizeMake(CGImageGetWidth(testImage.CGImage), CGImageGetHeight(testImage.CGImage));
    CGSize expectedImageSize = CGSizeMake(CGImageGetWidth(expectedImage.CGImage), CGImageGetHeight(expectedImage.CGImage));

    UIGraphicsBeginImageContext(testImageSize);
    [testImage drawInRect:CGRectMake(0.f, 0.f, testImageSize.width, testImageSize.height)];
    testImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContext(expectedImageSize);
    [expectedImage drawInRect:CGRectMake(0.f, 0.f, expectedImageSize.width, expectedImageSize.height)];
    expectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *testImageData = UIImagePNGRepresentation(testImage);
    NSData *expectedData = UIImagePNGRepresentation(expectedImage);

    return [testImageData isEqualToData:expectedData];
}

+ (void)saveImage:(UIImage *)image toPath:(NSString *)path
{
    /* Before you run test case, you can use the method to create and save expected images.
       
       For example:
        UIImage *originImage = [ImageTestUtils readImageNamed:@"icon-hambuger.png"];
        UIImage *expectedImage = [UIImage image:originImage replaceColor:[UIColor redColor]];
        [ImageTestUtils saveImage:expectedImage toPath:@"/path/you/want/expectedImage.png"];
     */
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileManager createFileAtPath:path contents:imageData attributes:nil];
}

@end
