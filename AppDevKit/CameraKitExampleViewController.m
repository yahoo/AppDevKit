//
//  CameraKitExampleViewController.m
//  AppDevKit
//
//  Created by  Chih Feng Sung on 6/29/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "CameraKitExampleViewController.h"
#import "ADKCamera.h"
#import "UIView+ADKAnimationMacro.h"

@interface CameraKitExampleViewController () <ADKCameraDelegate>

@property (strong, nonatomic) ADKCamera *cameraUtil;

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UISlider *lenFocusSlider;
@property (weak, nonatomic) IBOutlet UIButton *shootButton;

- (IBAction)lenFocusSliderChangeHandler:(id)sender;
- (IBAction)shootButtonTapHandler:(id)sender;

@end

@implementation CameraKitExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.title = @"ADKCamera";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.shootButton.layer.cornerRadius = CGRectGetWidth(self.shootButton.bounds) * 0.5f;

    self.previewImageView.alpha = 0.7f;

    [self initCamera];

}

- (void)initCamera
{
    self.cameraUtil = [[ADKCamera alloc] initCameraWithDelegate:self
                                                        quality:AVCaptureSessionPresetPhoto
                                                       position:ADKCameraPositionRear];
    self.cameraUtil.alignDeviceOrientation = YES;


    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
     {
         if(granted)
         {
             NSLog(@"Granted access to %@", AVMediaTypeVideo);

             [self.view.layer insertSublayer:self.cameraUtil.captureVideoPreviewLayer atIndex:0];

             self.cameraUtil.captureVideoPreviewLayer.frame = self.view.bounds;

             // Updating current lens focus calue
             self.lenFocusSlider.minimumValue = self.cameraUtil.minLensPosition;
             self.lenFocusSlider.maximumValue = self.cameraUtil.maxLensPosition;
             self.lenFocusSlider.value = self.cameraUtil.lensPosition;

             [self.cameraUtil startCamera];
         }
         else
         {
             NSLog(@"Not granted access to %@", AVMediaTypeVideo);

             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CameraKit Notice"
                                                                                      message:@"The camera premission is required for demo CameraKit!"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *closeAlertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          // Do nothing
                                                                      }];
             [alertController addAction:closeAlertAction];

             [self presentViewController:alertController
                                animated:YES
                              completion:^{
                                  // Do nothing
                              }];
         }
     }];

}



#pragma mark -- Event handlers

- (IBAction)lenFocusSliderChangeHandler:(id)sender
{
    self.cameraUtil.lensPosition = self.lenFocusSlider.value;
}

- (IBAction)shootButtonTapHandler:(id)sender
{
    UIButton *button = sender;
    [button popUpAnimation];


    [self.cameraUtil captureImage:^(UIImage *image, NSDictionary *exifDic, NSError *error) {

        NSLog(@">>>>> EXIF: %@", exifDic);
        self.previewImageView.image = image;
        [self.previewImageView popUpAnimation];


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *messageString;
            if (!error) {
                messageString = [NSString stringWithFormat:@"Shoot photo accomplished: %@", exifDic];
            } else {
                messageString = [NSString stringWithFormat:@"Shoot photo error: %@", error.description];
            }

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CameraKit Notice"
                                                                                     message:messageString
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAlertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         // Do nothing
                                                                     }];
            [alertController addAction:closeAlertAction];

            [self presentViewController:alertController
                               animated:YES
                             completion:^{
                                 // Do nothing
                             }];
        });
        
    }];
}

@end
