//
//  OpenGLRenderViewController.h
//  AppDevKit
//
//  Created by  Chih Feng Sung on 12/13/18.
//  Copyright © 2018 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLRenderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *demoImageView;

- (IBAction)drawScaleToFillImageButtonTapHandler:(id)sender;
- (IBAction)drawScaleAspectFillImageButtonTapHandler:(id)sender;
- (IBAction)drawScaleAspectFitImageButtonTapHandler:(id)sender;

@end

NS_ASSUME_NONNULL_END
