//
//  ImageTestUtils.h
//  AppDevKit
//
//  Created by Yu-Chen Shen on 2014/11/21.
//  Copyright © 2014, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTestUtils : NSObject

+ (UIImage *)readImageNamed:(NSString*)imageName;
+ (UIImage *)readImageNamed:(NSString *)imageName scale:(CGFloat)scale;
+ (BOOL)compareImage:(UIImage *)testImage toImage:(UIImage *)expectedImage;
+ (void)saveImage:(UIImage *)image toPath:(NSString *)path;

@end
