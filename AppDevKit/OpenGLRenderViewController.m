//
//  OpenGLRenderViewController.m
//  AppDevKit
//
//  Created by  Chih Feng Sung on 12/13/18.
//  Copyright © 2018 Yahoo. All rights reserved.
//

#import "OpenGLRenderViewController.h"
#import "AppDevCameraKit.h"

@interface OpenGLRenderViewController ()

@property (strong, nonatomic) ADKOpenGLImageView *openGLImageView;

@end

@implementation OpenGLRenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView
{
    self.title = @"ADKOpenGLImageView";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIImage *demoImage = [UIImage imageNamed:@"Landscape"];
    self.demoImageView.image = demoImage;

    self.openGLImageView = [[ADKOpenGLImageView alloc] initWithFrame:self.containerView.frame];
    // self.openGLImageView.contentMode = ADKOpenGLImageViewContentModeScaleAspectFill;
    [self.containerView addSubview:self.openGLImageView];
}

- (IBAction)drawImageButtonTapHandler:(id)sender
{
    NSLog(@"YO");
    self.openGLImageView.backgroundColor = [UIColor redColor];

    CIImage *coreImage = [CIImage imageWithCGImage:self.demoImageView.image.CGImage];
    self.openGLImageView.image = coreImage;
}

@end
