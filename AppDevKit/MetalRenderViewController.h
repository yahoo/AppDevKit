//
//  MetalRenderViewController.h
//  AppDevKit
//
//  Created by  Chih Feng Sung on 1/3/19.
//  Copyright © 2019 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetalRenderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *demoImageView;

- (IBAction)drawScaleToFillImageButtonTapHandler:(id)sender;
- (IBAction)drawScaleAspectFillImageButtonTapHandler:(id)sender;
- (IBAction)drawScaleAspectFitImageButtonTapHandler:(id)sender;

@end

NS_ASSUME_NONNULL_END
