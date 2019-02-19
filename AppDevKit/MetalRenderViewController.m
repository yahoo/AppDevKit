//
//  MetalRenderViewController.m
//  AppDevKit
//
//  Created by  Chih Feng Sung on 1/3/19.
//  Copyright © 2019 Yahoo. All rights reserved.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "MetalRenderViewController.h"
#import "AppDevCameraKit.h"

@interface MetalRenderViewController ()

@property (strong, nonatomic) ADKMetalImageView *metalImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *demoImageView;

- (IBAction)drawScaleToFillImageButtonTapHandler:(id)sender;
- (IBAction)drawScaleAspectFillImageButtonTapHandler:(id)sender;
- (IBAction)drawScaleAspectFitImageButtonTapHandler:(id)sender;

@end

@implementation MetalRenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.metalImageView = [[ADKMetalImageView alloc] initWithFrame:self.containerView.frame];
    self.metalImageView.backgroundColor = [UIColor lightGrayColor];
    [self.containerView addSubview:self.metalImageView];
}

- (void)setupView
{
    self.title = @"ADKMetalImageView";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIImage *demoImage = [UIImage imageNamed:@"Landscape"];
    self.demoImageView.image = demoImage;
}

- (IBAction)drawScaleToFillImageButtonTapHandler:(id)sender
{
    self.metalImageView.contentMode = ADKMetalImageViewContentModeScaleToFill;
    [self renderImage];
}

- (IBAction)drawScaleAspectFillImageButtonTapHandler:(id)sender
{
    self.metalImageView.contentMode = ADKMetalImageViewContentModeScaleAspectFill;
    [self renderImage];
}

- (IBAction)drawScaleAspectFitImageButtonTapHandler:(id)sender
{
    self.metalImageView.contentMode = ADKMetalImageViewContentModeScaleAspectFit;
    [self renderImage];
}

- (void)renderImage
{
    CIImage *inputCoreImage = [CIImage imageWithCGImage:self.demoImageView.image.CGImage];

    CIFilter *instantFilter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
    [instantFilter setValue:inputCoreImage forKey:kCIInputImageKey];

    self.metalImageView.image = instantFilter.outputImage;
}


@end
