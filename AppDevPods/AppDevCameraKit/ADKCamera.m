//
//  ADKCamera.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 9/1/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <ImageIO/CGImageProperties.h>
#import "ADKCamera.h"

NSString *const ADKCameraErrorDomain = @"ADKCameraErrorDomain";

static void *AdjustingFocusContext = &AdjustingFocusContext;
static void *AdjustingExposureContext = &AdjustingExposureContext;
static void *AdjustingWhiteBalanceContext = &AdjustingWhiteBalanceContext;
static void *SessionRunningContext = &SessionRunningContext;
static void *FocusModeContext = &FocusModeContext;
static void *ExposureModeContext = &ExposureModeContext;
static void *WhiteBalanceModeContext = &WhiteBalanceModeContext;
static void *LensPositionContext = &LensPositionContext;
static void *ExposureDurationContext = &ExposureDurationContext;
static void *ISOContext = &ISOContext;
static void *ExposureTargetBiasContext = &ExposureTargetBiasContext;
static void *ExposureTargetOffsetContext = &ExposureTargetOffsetContext;
static void *DeviceWhiteBalanceGainsContext = &DeviceWhiteBalanceGainsContext;


@interface ADKCamera () <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) NSString *cameraQuality;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *videoCaptureDevice;
@property (strong, nonatomic) AVCaptureDevice *audioCaptureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *videoCaptureDeviceInput;
@property (strong, nonatomic) AVCaptureDeviceInput *audioCaptureDeviceInput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;
// TODO: It will be implemented for iOS 10 SDK
// @property (strong, nonatomic) AVCapturePhotoOutput *capturePhotoOutput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
@property (assign, nonatomic) AVCaptureWhiteBalanceGains whiteBalanceGains;
@property (assign, nonatomic) BOOL camcoderMode;
@property (assign, nonatomic) BOOL recording;
@property (copy, nonatomic) void (^movieRecordingCompletionBlock)(NSURL *videoOutputURL, NSError *error);

@end


@implementation ADKCamera


#pragma mark -- Class methods

+ (BOOL)cameraPermission
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)microphonePermission
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusAuthorized) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)frontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)rearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


#pragma mark -- Initialize methods

- (void)dealloc
{
    [self removeObservers];
}

- (instancetype)initCameraWithDelegate:(id)delegate quality:(NSString *)cameraQuality position:(ADKCameraPosition)cameraPosition
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setupDefaultSetting];

        self.cameraQuality = cameraQuality;
        self.cameraPosition = cameraPosition;

        [self initializeCamera];

        [self addObservers];
    }
    return self;
}

- (instancetype)initCamcoderWithDelegate:(id)delegate quality:(NSString *)cameraQuality position:(ADKCameraPosition)cameraPosition
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setupDefaultSetting];

        self.cameraQuality = cameraQuality;
        self.cameraPosition = cameraPosition;
        self.camcoderMode = YES;

        [self initializeCamera];
        [self addObservers];
    }
    return self;
}

- (void)setupDefaultSetting
{
    self.alignDeviceOrientation = NO;

    self.cameraQuality = AVCaptureSessionPresetHigh;
    self.cameraPosition = ADKCameraPositionRear;
    self.cameraFlashMode = ADKCameraFlashModeOff;
    self.cameraTorchMode = ADKCameraTorchModeOff;
    self.cameraMirrorMode = ADKCameraMirrorModeAuto;
    self.cameraFocusMode = ADKCameraFocusModeAutoFocus;
    self.cameraExposureMode = ADKCameraExposureModeAutoExposure;
    self.cameraWhiteBlanceMode = ADKCameraWhiteBlanceModeAutoWhiteBalance;
}

- (void)initializeCamera
{
    if (![ADKCamera cameraPermission]) {
        return;
    }

    if (self.captureSession == nil) {
        // Initialize AVCaptureSession
        self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.sessionPreset = self.cameraQuality;

        // Initialize AVCaptureDevice
        AVCaptureDevicePosition captureDevicePosition = AVCaptureDevicePositionUnspecified;
        switch (self.cameraPosition) {
            case ADKCameraPositionRear:
                if ([ADKCamera rearCameraAvailable]) {
                    captureDevicePosition = AVCaptureDevicePositionBack;
                }
                break;
            case ADKCameraPositionFront:
                if ([ADKCamera frontCameraAvailable]) {
                    captureDevicePosition = AVCaptureDevicePositionFront;
                }
                break;
            default:
                break;
        }

        if (self.cameraPosition == ADKCameraPositionUnspecified) {
            self.videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        } else {
            self.videoCaptureDevice = [self captureDeviceWithCameraPosition:captureDevicePosition];
        }

        // Initialize AVCaptureDeviceInput
        NSError *error = nil;
        self.videoCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoCaptureDevice error:&error];
        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
            return;
        }

        if ([self.captureSession canAddInput:self.videoCaptureDeviceInput]) {
            [self.captureSession addInput:self.videoCaptureDeviceInput];
        } else {
            [self handleErrorWithCode:ADKCameraErrorCodeSession description:@"The session can't add capture input in initialized flow."];
            return;
        }

        self.captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
        self.captureStillImageOutput.outputSettings = outputSettings;
        if ([self.captureSession canAddOutput:self.captureStillImageOutput]) {
            [self.captureSession addOutput:self.captureStillImageOutput];
        } else {
            [self handleErrorWithCode:ADKCameraErrorCodeSession description:@"The session can't add capture output in initialized flow."];
            return;
        }

        if (self.camcoderMode) {
            self.audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
            self.audioCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioCaptureDevice error:&error];

            if (error) {
                [self handleErrorWithCode:error.code userInfo:error.userInfo];
            }

            if ([self.captureSession canAddInput:self.audioCaptureDeviceInput]) {
                [self.captureSession addInput:self.audioCaptureDeviceInput];
            }

            self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];

            if ([self.captureSession canAddOutput:self.captureMovieFileOutput]) {
                [self.captureSession addOutput:self.captureMovieFileOutput];
            }
        }
    }
}


#pragma mark -- Help methods

- (BOOL)flashAvailable
{
    if (!self.videoCaptureDevice) {
        return NO;
    }

    return self.videoCaptureDevice.hasFlash && self.videoCaptureDevice.isFlashAvailable;
}

- (BOOL)torchAvailable
{
    if (!self.videoCaptureDevice) {
        return NO;
    }

    return self.videoCaptureDevice.hasTorch && self.videoCaptureDevice.isTorchAvailable;
}


#pragma mark -- Camera feature methods

- (void)optimizeForHighestFrameRate
{
    if (self.videoCaptureDevice) {
        [self configureCameraForHighestFrameRate:self.videoCaptureDevice];
    }
}

- (void)startCamera
{
    if (self.captureSession) {
        [self.captureSession startRunning];
        [self updateCameraStatus];
    }
}

- (void)stopCamera
{
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)focusAtPoint:(CGPoint)focusPoint
{
    AVCaptureDevice *captureDevice = self.videoCaptureDevice;
    if (captureDevice.isFocusPointOfInterestSupported && [captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([captureDevice lockForConfiguration:&error]) {
            captureDevice.focusPointOfInterest = focusPoint;
            captureDevice.focusMode = AVCaptureFocusModeAutoFocus;
            [captureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (void)exposureAtPoint:(CGPoint)exposurePoint
{
    AVCaptureDevice *captureDevice = self.videoCaptureDevice;
    if (captureDevice.isExposurePointOfInterestSupported && [captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        NSError *error;
        if ([captureDevice lockForConfiguration:&error]) {
            captureDevice.exposurePointOfInterest = exposurePoint;
            captureDevice.exposureMode = AVCaptureExposureModeAutoExpose;
            [captureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (void)captureImage:(void (^)(UIImage *, NSDictionary *, NSError *))completionBlock
{
    if (!self.captureSession) {
        NSError *error = [NSError errorWithDomain:ADKCameraErrorDomain
                                             code:ADKCameraErrorCodeSession
                                         userInfo:nil];
        completionBlock(nil, nil, error);
        return;
    }

    // set video orientation
    AVCaptureConnection *captureConnection = [self captureConnectionWithCaptureOutput:self.captureStillImageOutput];
    // TODO: It will be implemented for iOS 10 SDK
    // AVCaptureConnection *captureConnection = [self captureConnectionWithCaptureOutput:self.capturePhotoOutput];
    if (captureConnection.isVideoOrientationSupported) {
        captureConnection.videoOrientation = [self captureVideoOrientation];
    }

    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection
                                                              completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

                                                                  UIImage *image;
                                                                  NSDictionary *exifDic;

                                                                  if (imageDataSampleBuffer) {
                                                                      NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                                      image = [[UIImage alloc] initWithData:imageData];

                                                                      CFDictionaryRef exifDicRef = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                                      if (exifDicRef) {
                                                                          exifDic = (__bridge NSDictionary *)(exifDicRef);
                                                                      }
                                                                  }

                                                                  if (completionBlock) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          completionBlock(image, exifDic, error);
                                                                      });
                                                                  }
                                                              }];

    // TODO: It will be implemented for iOS 10 SDK
    // [self.capturePhotoOutput capturePhotoWithSettings:nil delegate:<#(nonnull id<AVCapturePhotoCaptureDelegate>)#>]
}

- (void)startCaptureVideo:(void (^)(NSURL *, NSError *))completionBlock outputURL:(NSURL *)videoOutputURL
{
    if (!self.camcoderMode) {
        [self handleErrorWithCode:ADKCameraErrorCodeNotCamcoder description:@"The session doesn't support camcoder mode. Please use initCamcoderWithDelegate:quality:position: to initialize new instance."];
        return;
    }

    if (self.recording) {
        [self handleErrorWithCode:ADKCameraErrorCodeMovieRecording description:@"Moview is recording. Please stop record before you record another new one."];
        return;
    }

    // set video orientation
    AVCaptureConnection *captureConnection = [self captureConnectionWithCaptureOutput:self.captureMovieFileOutput];
    if (captureConnection.isVideoOrientationSupported) {
        captureConnection.videoOrientation = [self captureVideoOrientation];
    }

    self.movieRecordingCompletionBlock = completionBlock;
    [self.captureMovieFileOutput startRecordingToOutputFileURL:videoOutputURL
                                             recordingDelegate:self];
}

- (void)stopCaptureVideo
{
    if (!self.camcoderMode) {
        return;
    }

    [self.captureMovieFileOutput stopRecording];
}


#pragma mark -- Property setter and getter

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer
{
    if (_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer.connection.videoOrientation = [self captureVideoOrientation];
        return _captureVideoPreviewLayer;
    }

    if (self.captureSession) {
        self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _captureVideoPreviewLayer.connection.videoOrientation = [self captureVideoOrientation];
        return _captureVideoPreviewLayer;
    }

    return nil;
}

- (void)setCameraPosition:(ADKCameraPosition)cameraPosition
{
    if (!self.captureSession || cameraPosition == self.cameraPosition) {
        return;
    }

    if ((cameraPosition == ADKCameraPositionFront && ![ADKCamera frontCameraAvailable]) || (cameraPosition == ADKCameraPositionRear && ![ADKCamera rearCameraAvailable])) {
        return;
    }

    [self.captureSession beginConfiguration];

    [self.captureSession removeInput:self.videoCaptureDeviceInput];

    AVCaptureDevice *captureDevice = nil;
    if (cameraPosition == ADKCameraPositionFront) {
        captureDevice = [self captureDeviceWithCameraPosition:AVCaptureDevicePositionFront];
    } else if (cameraPosition == ADKCameraPositionRear) {
        captureDevice = [self captureDeviceWithCameraPosition:AVCaptureDevicePositionBack];
    }

    if (!captureDevice) {
        return;
    }

    NSError *error = nil;
    AVCaptureDeviceInput *videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if(error) {
        [self handleErrorWithCode:error.code userInfo:error.userInfo];
        [self.captureSession commitConfiguration];
        return;
    }

    [self.captureSession addInput:videoCaptureDeviceInput];

    [self.captureSession commitConfiguration];


    self.videoCaptureDeviceInput = videoCaptureDeviceInput;
    [self updateCameraStatus];

    _cameraPosition = cameraPosition;
}

- (void)setCameraFlashMode:(ADKCameraFlashMode)cameraFlashMode
{
    if(![self flashAvailable]) {
        [self handleErrorWithCode:ADKCameraErrorCodeFlashUnavailable description:@"This device doesn't support flash feature."];
        return;
    }

    AVCaptureFlashMode flashMode;
    switch (cameraFlashMode) {
        case ADKCameraFlashModeOff:
            flashMode = AVCaptureFlashModeOff;
            break;
        case ADKCameraFlashModeOn:
            flashMode = AVCaptureFlashModeOn;
            break;
        case ADKCameraFlashModeAuto:
            flashMode = AVCaptureFlashModeAuto;
            break;
    }

    NSError *error;
    if ([self.videoCaptureDevice lockForConfiguration:&error]) {
        self.videoCaptureDevice.flashMode = flashMode;
        [self.videoCaptureDevice unlockForConfiguration];
    }

    if (error) {
        [self handleErrorWithCode:error.code userInfo:error.userInfo];
    }

    _cameraFlashMode = cameraFlashMode;
}

- (void)setCameraTorchMode:(ADKCameraTorchMode)cameraTorchMode
{
    if(![self torchAvailable]) {
        [self handleErrorWithCode:ADKCameraErrorCodeTorchUnabailable description:@"This device doesn't support flash feature."];
        return;
    }

    AVCaptureTorchMode captureTorchMode;
    switch (cameraTorchMode) {
        case ADKCameraTorchModeOn:
            captureTorchMode = AVCaptureTorchModeOn;
            break;
        case ADKCameraTorchModeOff:
            captureTorchMode = AVCaptureTorchModeOff;
            break;
    }

    NSError *error;
    if ([self.videoCaptureDevice lockForConfiguration:&error]) {
        [self.videoCaptureDevice setTorchMode:captureTorchMode];
        [self.videoCaptureDevice unlockForConfiguration];
    }

    if (error) {
        [self handleErrorWithCode:error.code userInfo:error.userInfo];
    }

    _cameraTorchMode = cameraTorchMode;
}

- (void)setCameraMirrorMode:(ADKCameraMirrorMode)cameraMirrorMode
{
    AVCaptureConnection *videoConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureConnection *photoConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];

    switch (cameraMirrorMode) {
        case ADKCameraMirrorModeOff: {
            if ([videoConnection isVideoMirroringSupported]) {
                videoConnection.videoMirrored = NO;
            }
            if ([photoConnection isVideoMirroringSupported]) {
                photoConnection.videoMirrored = NO;
            }
            break;
        }
        case ADKCameraMirrorModeOn: {
            if ([videoConnection isVideoMirroringSupported]) {
                videoConnection.videoMirrored = YES;
            }
            if ([photoConnection isVideoMirroringSupported]) {
                photoConnection.videoMirrored = YES;
            }
            break;
        }
        case ADKCameraMirrorModeAuto: {
            if ([videoConnection isVideoMirroringSupported]) {
                videoConnection.videoMirrored = (self.cameraPosition == ADKCameraPositionFront);
            }
            if ([photoConnection isVideoMirroringSupported]) {
                photoConnection.videoMirrored = (self.cameraPosition == ADKCameraPositionFront);
            }
            break;
        }
    }

    _cameraMirrorMode = cameraMirrorMode;
}

- (void)setCameraFocusMode:(ADKCameraFocusMode)cameraFocusMode
{
    AVCaptureFocusMode focusMode;
    switch (cameraFocusMode) {
        case ADKCameraFocusModeLocked:
            focusMode = AVCaptureFocusModeLocked;
            break;
        case ADKCameraFocusModeAutoFocus:
            focusMode = AVCaptureFocusModeAutoFocus;
            break;
        case ADKCameraFocusModeContinuousAutoFocus:
            focusMode = AVCaptureFocusModeContinuousAutoFocus;
            break;
    }

    NSError *error;
    if ([self.videoCaptureDevice lockForConfiguration:&error]) {
        if ([self.videoCaptureDevice isFocusModeSupported:focusMode]) {
            self.videoCaptureDevice.focusMode = focusMode;
            _cameraFocusMode = cameraFocusMode;
        }
        [self.videoCaptureDevice unlockForConfiguration];
    }

    if (error) {
        [self handleErrorWithCode:error.code userInfo:error.userInfo];
    }
}

- (void)setCameraExposureMode:(ADKCameraExposureMode)cameraExposureMode
{
    AVCaptureExposureMode exposureMode;
    switch (cameraExposureMode) {
        case ADKCameraExposureModeLocked:
            exposureMode = AVCaptureExposureModeLocked;
            break;
        case ADKCameraExposureModeAutoExposure:
            exposureMode = AVCaptureExposureModeAutoExpose;
            break;
        case ADKCameraExposureModeContinuousAutoExposure:
            exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            break;
    }

    NSError *error;
    if ([self.videoCaptureDevice lockForConfiguration:&error]) {
        if ([self.videoCaptureDevice isExposureModeSupported:exposureMode]) {
            self.videoCaptureDevice.exposureMode = exposureMode;
            _cameraExposureMode = cameraExposureMode;
        }
        [self.videoCaptureDevice unlockForConfiguration];
    }

    if (error) {
        [self handleErrorWithCode:error.code userInfo:error.userInfo];
    }
}

- (void)setCameraWhiteBlanceMode:(ADKCameraWhiteBlanceMode)cameraWhiteBlanceMode
{
    AVCaptureWhiteBalanceMode whiteBlanceMode;
    switch (cameraWhiteBlanceMode) {
        case ADKCameraWhiteBlanceModeLocked:
            whiteBlanceMode = AVCaptureWhiteBalanceModeLocked;
            break;
        case ADKCameraWhiteBlanceModeAutoWhiteBalance:
            whiteBlanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
            break;
        case ADKCameraWhiteBlanceModeContinuousAutoWhiteBalance:
            whiteBlanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            break;
    }

    NSError *error;
    if ([self.videoCaptureDevice lockForConfiguration:&error]) {
        if ([self.videoCaptureDevice isWhiteBalanceModeSupported:whiteBlanceMode]) {
            self.videoCaptureDevice.whiteBalanceMode = whiteBlanceMode;
            _cameraWhiteBlanceMode = cameraWhiteBlanceMode;
        }
        [self.videoCaptureDevice unlockForConfiguration];
    }

    if (error) {
        [self handleErrorWithCode:error.code userInfo:error.userInfo];
    }
}

- (CGFloat)minExposureBias
{
    CGFloat minExposureBias = NAN;
    if (self.videoCaptureDevice) {
        minExposureBias = self.videoCaptureDevice.minExposureTargetBias;
    }

    return minExposureBias;
}

- (CGFloat)maxExposureBias
{
    CGFloat maxExposureBias = NAN;
    if (self.videoCaptureDevice) {
        maxExposureBias = self.videoCaptureDevice.maxExposureTargetBias;
    }

    return maxExposureBias;
}

- (void)setExposureBias:(CGFloat)exposureBias
{
    if (self.videoCaptureDevice) {
        exposureBias = MAX(exposureBias, self.minExposureBias);
        exposureBias = MIN(exposureBias, self.maxExposureBias);

        NSError *error;
        if ([self.videoCaptureDevice lockForConfiguration:&error]) {
            [self.videoCaptureDevice setExposureTargetBias:exposureBias
                                         completionHandler:^(CMTime syncTime) {
                                             // Do nothing
                                         }];
            [self.videoCaptureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (CGFloat)exposureBias
{
    CGFloat exposureBias = NAN;
    if (self.videoCaptureDevice) {
        exposureBias = self.videoCaptureDevice.exposureTargetBias;
    }

    return exposureBias;
}

- (CGFloat)minShutterSpeed
{
    CGFloat minShutterSpeed = NAN;
    if (self.videoCaptureDevice) {
        AVCaptureDeviceFormat *captureDeviceFormat = self.videoCaptureDevice.activeFormat;
        minShutterSpeed = CMTimeGetSeconds(captureDeviceFormat.minExposureDuration);
    }

    return minShutterSpeed;
}

- (CGFloat)maxShutterSpeed
{
    CGFloat maxShutterSpeed = NAN;
    if (self.videoCaptureDevice) {
        AVCaptureDeviceFormat *captureDeviceFormat = self.videoCaptureDevice.activeFormat;
        maxShutterSpeed = CMTimeGetSeconds(captureDeviceFormat.maxExposureDuration);
    }

    return maxShutterSpeed;
}

- (void)setShutterSpeed:(CGFloat)shutterSpeed
{
    if (self.videoCaptureDevice) {
        shutterSpeed = MIN(shutterSpeed, self.maxShutterSpeed);
        shutterSpeed = MAX(shutterSpeed, self.minShutterSpeed);

        NSError *error;
        if ([self.videoCaptureDevice lockForConfiguration:&error]) {
            [self.videoCaptureDevice setExposureModeCustomWithDuration:CMTimeMakeWithSeconds(shutterSpeed, 1000*1000*1000)
                                                                   ISO:AVCaptureISOCurrent
                                                     completionHandler:^(CMTime syncTime) {
                                                         // Do nothing
                                                     }];
            [self.videoCaptureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (CGFloat)shutterSpeed
{
    CGFloat shutterSpeed = NAN;
    if (self.videoCaptureDevice) {
        shutterSpeed = CMTimeGetSeconds(self.videoCaptureDevice.exposureDuration);
    }

    return shutterSpeed;
}

- (CGFloat)minISO
{
    CGFloat minISO = NAN;
    if (self.videoCaptureDevice) {
        minISO = self.videoCaptureDevice.activeFormat.minISO;
    }

    return minISO;
}

- (CGFloat)maxISO
{
    CGFloat maxISO = NAN;
    if (self.videoCaptureDevice) {
        maxISO = self.videoCaptureDevice.activeFormat.maxISO;
    }

    return maxISO;
}

- (void)setISO:(CGFloat)ISO
{
    if (self.videoCaptureDevice) {
        ISO = MIN(ISO, self.maxISO);
        ISO = MAX(ISO, self.minISO);

        NSError *error;
        if ([self.videoCaptureDevice lockForConfiguration:&error]) {
            [self.videoCaptureDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent
                                                                   ISO:ISO
                                                     completionHandler:^(CMTime syncTime) {
                                                         // Do nothing
                                                     }];
            [self.videoCaptureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (CGFloat)ISO
{
    CGFloat ISO = 0.0f;
    if (self.videoCaptureDevice) {
        ISO = self.videoCaptureDevice.ISO;
    }

    return ISO;
}

- (CGFloat)minZoomFactor
{
    return 1.0f;
}

- (CGFloat)maxZoomFactor
{
    CGFloat maxZoomFactor = NAN;
    if (self.videoCaptureDevice) {
        maxZoomFactor = self.videoCaptureDevice.activeFormat.videoMaxZoomFactor;
    }

    return maxZoomFactor;
}

- (void)setZoomFactor:(CGFloat)zoomFactor
{
    if (self.videoCaptureDevice) {
        zoomFactor = MIN(zoomFactor, self.maxZoomFactor);
        zoomFactor = MAX(zoomFactor, self.minZoomFactor);

        NSError *error;
        if ([self.videoCaptureDevice lockForConfiguration:&error]) {
            [self.videoCaptureDevice rampToVideoZoomFactor:zoomFactor withRate:200.0f];
            [self.videoCaptureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (CGFloat)zoomFactor
{
    CGFloat zoomFactor = NAN;
    if (self.videoCaptureDevice) {
        zoomFactor = self.videoCaptureDevice.videoZoomFactor;
    }

    return zoomFactor;
}

- (void)setLensPosition:(CGFloat)lensPosition
{
    if (self.videoCaptureDevice) {
        NSError *error;
        if ([self.videoCaptureDevice lockForConfiguration:&error]) {
            [self.videoCaptureDevice setFocusModeLockedWithLensPosition:lensPosition
                                                      completionHandler:^(CMTime syncTime) {
                                                          // Do nothing
                                                      }];
            [self.videoCaptureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (CGFloat)minLensPosition
{
    return 0.0f;
}

- (CGFloat)maxLensPosition
{
    return 1.0f;
}

- (CGFloat)lensPosition
{
    CGFloat lensPosition = NAN;
    if (self.videoCaptureDevice) {
        lensPosition = self.videoCaptureDevice.lensPosition;
    }

    return lensPosition;
}

- (void)setWhiteBalanceGains:(AVCaptureWhiteBalanceGains)whiteBalanceGains
{
    if (self.videoCaptureDevice) {
        AVCaptureWhiteBalanceGains normalizedWhiteBalanceGains = [self normalizedGains:whiteBalanceGains];

        NSError *error;
        if ([self.videoCaptureDevice lockForConfiguration:&error]) {
            [self.videoCaptureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:normalizedWhiteBalanceGains
                                                                        completionHandler:^(CMTime syncTime) {
                                                                            // Do nothing
                                                                        }];
            [self.videoCaptureDevice unlockForConfiguration];
        }

        if (error) {
            [self handleErrorWithCode:error.code userInfo:error.userInfo];
        }
    }
}

- (AVCaptureWhiteBalanceGains)whiteBalanceGains
{
    AVCaptureWhiteBalanceGains whiteBalanceGains = AVCaptureWhiteBalanceGainsCurrent;
    if (self.videoCaptureDevice) {
        whiteBalanceGains = [self normalizedGains:[self.videoCaptureDevice deviceWhiteBalanceGains]];
    }

    return whiteBalanceGains;
}

- (CGFloat)minWhiteBalanceTemperature
{
    return 1700.0;
}

- (CGFloat)maxWhiteBalanceTemperature
{
    return 27000.0f;
}

- (void)setWhiteBalanceTemperature:(CGFloat)whiteBalanceTemperature
{
    // Color temperature definition of Kelvin https://en.wikipedia.org/wiki/Color_temperature#cite_note-4

    if (self.videoCaptureDevice) {
        whiteBalanceTemperature = MIN(whiteBalanceTemperature, self.maxWhiteBalanceTemperature);
        whiteBalanceTemperature = MAX(whiteBalanceTemperature, self.minWhiteBalanceTemperature);

        AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = {
            .temperature = whiteBalanceTemperature,
            .tint = self.whiteBalanceTint,
        };

        AVCaptureWhiteBalanceGains whiteBalanceGains = [self.videoCaptureDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:temperatureAndTintValues];
        self.whiteBalanceGains = whiteBalanceGains;
    }
}

- (CGFloat)whiteBalanceTemperature
{
    CGFloat whiteBalanceTemperature = NAN;
    if (self.videoCaptureDevice) {
        AVCaptureWhiteBalanceGains whiteBalanceGains = [self whiteBalanceGains];
        AVCaptureWhiteBalanceTemperatureAndTintValues whiteBalanceTemperatureAndTintValues = [self.videoCaptureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:whiteBalanceGains];
        whiteBalanceTemperature = whiteBalanceTemperatureAndTintValues.temperature;
    }

    return whiteBalanceTemperature;
}

- (CGFloat)minWhiteBalanceTint
{
    return -150.0f;
}

- (CGFloat)maxWhiteBalanceTint
{
    return 150.0f;
}

- (void)setWhiteBalanceTint:(CGFloat)whiteBalanceTint
{
    if (self.videoCaptureDevice) {
        AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = {
            .temperature = self.whiteBalanceTemperature,
            .tint = whiteBalanceTint,
        };

        AVCaptureWhiteBalanceGains whiteBalanceGains = [self.videoCaptureDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:temperatureAndTintValues];
        self.whiteBalanceGains = whiteBalanceGains;
    }
}

- (CGFloat)whiteBalanceTint
{
    CGFloat whiteBalanceTint = NAN;
    if (self.videoCaptureDevice) {
        AVCaptureWhiteBalanceGains whiteBalanceGains = [self whiteBalanceGains];
        AVCaptureWhiteBalanceTemperatureAndTintValues whiteBalanceTemperatureAndTintValues = [self.videoCaptureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:whiteBalanceGains];
        whiteBalanceTint = whiteBalanceTemperatureAndTintValues.tint;
    }

    return whiteBalanceTint;
}

- (void)setLowLightBoost:(BOOL)lowLightBoost
{
    if ([self.videoCaptureDevice isLowLightBoostSupported]) {
        self.videoCaptureDevice.automaticallyEnablesLowLightBoostWhenAvailable = lowLightBoost;

        _lowLightBoost = lowLightBoost;
    }
}

- (void)setStabilization:(BOOL)stabilization
{
    AVCaptureVideoStabilizationMode stabilizationMode = AVCaptureVideoStabilizationModeOff;
    if (stabilization) {
        stabilizationMode = AVCaptureVideoStabilizationModeCinematic;
    }

    if (self.camcoderMode) {
        AVCaptureConnection *videoCaptureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        if (videoCaptureConnection.isVideoStabilizationSupported) {
            videoCaptureConnection.preferredVideoStabilizationMode = stabilizationMode;
        }
    }

    self.captureStillImageOutput.lensStabilizationDuringBracketedCaptureEnabled = stabilization;
    AVCaptureConnection *photoConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (photoConnection.isVideoStabilizationSupported) {
        photoConnection.preferredVideoStabilizationMode = stabilizationMode;
    }
}


#pragma mark -- Private supported methods

- (AVCaptureDevice *)captureDeviceWithCameraPosition:(AVCaptureDevicePosition)cameraPosition
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == cameraPosition) {
            return device;
        }
    }

    return nil;
}

- (AVCaptureConnection *)captureConnectionWithCaptureOutput:(AVCaptureOutput *)expactedCaptureOutput
{
    AVCaptureConnection *captureConnection = nil;
    for (AVCaptureConnection *connection in expactedCaptureOutput.connections) {
        for (AVCaptureInputPort *inputPort in connection.inputPorts) {
            if ([inputPort.mediaType isEqual:AVMediaTypeVideo]) {
                captureConnection = connection;
                break;
            }
        }
    }

    return captureConnection;
}

- (AVCaptureVideoOrientation)captureVideoOrientation
{
    AVCaptureVideoOrientation orientation;

    if(self.alignDeviceOrientation) {
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationLandscapeLeft:
                orientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIDeviceOrientationLandscapeRight:
                orientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                orientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
                orientation = AVCaptureVideoOrientationPortrait;
                break;
        }
    } else {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                orientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case UIInterfaceOrientationLandscapeRight:
                orientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                orientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
                orientation = AVCaptureVideoOrientationPortrait;
                break;
        }
    }

    return orientation;
}

- (void)updateCameraStatus
{
    self.cameraMirrorMode = _cameraMirrorMode;
    self.cameraFlashMode = _cameraFlashMode;
}

- (void)configureCameraForHighestFrameRate:(AVCaptureDevice *)captureDevice
{
    AVCaptureDeviceFormat *bestFormat = nil;
    AVFrameRateRange *bestFrameRateRange = nil;

    for (AVCaptureDeviceFormat *format in [captureDevice formats]) {
        for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges) {
            if (range.maxFrameRate > bestFrameRateRange.maxFrameRate) {
                bestFormat = format;
                bestFrameRateRange = range;
            }
        }
    }

    if (bestFormat) {
        if ([captureDevice lockForConfiguration:NULL] == YES) {
            captureDevice.activeFormat = bestFormat;
            captureDevice.activeVideoMinFrameDuration = bestFrameRateRange.minFrameDuration;
            captureDevice.activeVideoMaxFrameDuration = bestFrameRateRange.minFrameDuration;
            [captureDevice unlockForConfiguration];
        }
    }
}

- (AVCaptureWhiteBalanceGains)normalizedGains:(AVCaptureWhiteBalanceGains)gains
{
    gains.redGain = MAX(gains.redGain, 1.0f);
    gains.greenGain = MAX(gains.greenGain, 1.0f);
    gains.blueGain = MAX(gains.blueGain, 1.0f);

    gains.redGain = MIN(gains.redGain, self.videoCaptureDevice.maxWhiteBalanceGain);
    gains.greenGain = MIN(gains.greenGain, self.videoCaptureDevice.maxWhiteBalanceGain);
    gains.blueGain = MIN(gains.blueGain, self.videoCaptureDevice.maxWhiteBalanceGain);

    return gains;
}

- (void)handleError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:didFailWithError:)]) {
        [self.delegate ADKCamera:self didFailWithError:error];
    }
}

- (void)handleErrorWithCode:(ADKCameraErrorCode)errorCode description:(NSString *)errorDescription
{
    NSDictionary *userInfo = nil;
    if (errorDescription) {
        userInfo = [NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey];
    }

    NSError *error = [NSError errorWithDomain:ADKCameraErrorDomain
                                         code:errorCode
                                     userInfo:userInfo];

    [self handleError:error];
}

- (void)handleErrorWithCode:(ADKCameraErrorCode)errorCode userInfo:(NSDictionary *)userInfo
{
    NSError *error = [NSError errorWithDomain:ADKCameraErrorDomain
                                         code:errorCode
                                     userInfo:userInfo];

    [self handleError:error];
}


#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate delegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // Will add some logic to handle video buffer
}


#pragma mark -- AVCaptureFileOutputRecordingDelegate delegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    self.recording = YES;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (self.movieRecordingCompletionBlock) {
        self.movieRecordingCompletionBlock(outputFileURL, error);
    }

    self.recording = NO;
}


#pragma mark KVO and Notifications

- (void)addObservers
{
    [self.videoCaptureDevice addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:AdjustingFocusContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:AdjustingExposureContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"adjustingWhiteBalance" options:NSKeyValueObservingOptionNew context:AdjustingWhiteBalanceContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"focusMode" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:FocusModeContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"lensPosition" options:NSKeyValueObservingOptionNew context:LensPositionContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"exposureMode" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:ExposureModeContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"exposureDuration" options:NSKeyValueObservingOptionNew context:ExposureDurationContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"ISO" options:NSKeyValueObservingOptionNew context:ISOContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"exposureTargetBias" options:NSKeyValueObservingOptionNew context:ExposureTargetBiasContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"exposureTargetOffset" options:NSKeyValueObservingOptionNew context:ExposureTargetOffsetContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"whiteBalanceMode" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:WhiteBalanceModeContext];
    [self.videoCaptureDevice addObserver:self forKeyPath:@"deviceWhiteBalanceGains" options:NSKeyValueObservingOptionNew context:DeviceWhiteBalanceGainsContext];
    [self.captureSession addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
}

- (void)removeObservers
{
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"adjustingExposure"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"adjustingWhiteBalance"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"focusMode"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"lensPosition"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"exposureMode"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"exposureDuration"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"ISO"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"exposureTargetBias"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"exposureTargetOffset"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"whiteBalanceMode"];
    [self.videoCaptureDevice removeObserver:self forKeyPath:@"deviceWhiteBalanceGains"];
    [self.captureSession removeObserver:self forKeyPath:@"running"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // id oldChangeValue = change[NSKeyValueChangeOldKey];
    id newChangeValue = change[NSKeyValueChangeNewKey];
    if (newChangeValue == [NSNull null]) return;

    if (context == AdjustingFocusContext) {
        BOOL adjustFocus = [newChangeValue isEqualToNumber:[NSNumber numberWithInt:1]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:focusIsAdjusting:)]) {
            [self.delegate ADKCamera:self focusIsAdjusting:adjustFocus];
        }
    }

    if (context == AdjustingExposureContext) {
        BOOL adjustExposure = [newChangeValue isEqualToNumber:[NSNumber numberWithInt:1]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:exposureIsAdjusting:)]) {
            [self.delegate ADKCamera:self exposureIsAdjusting:adjustExposure];
        }
    }

    if (context == AdjustingWhiteBalanceContext) {
        BOOL adjustWhiteBalance = [newChangeValue isEqualToNumber:[NSNumber numberWithInt:1]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:whiteBalanceIsAdjusting:)]) {
            [self.delegate ADKCamera:self whiteBalanceIsAdjusting:adjustWhiteBalance];
        }
    }

    if (context == FocusModeContext) {
        AVCaptureFocusMode originalFocusMode = [newChangeValue integerValue];
        ADKCameraFocusMode focusMode;

        switch (originalFocusMode) {
            case AVCaptureFocusModeLocked:
                focusMode = ADKCameraFocusModeLocked;
                break;
            case AVCaptureFocusModeAutoFocus:
                focusMode = ADKCameraFocusModeAutoFocus;
                break;
            case AVCaptureFocusModeContinuousAutoFocus:
                focusMode = ADKCameraFocusModeContinuousAutoFocus;
                break;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:focusModeChanged:)]) {
            [self.delegate ADKCamera:self focusModeChanged:focusMode];
        }
    }

    if (context == LensPositionContext) {
        AVCaptureDevicePosition originalLensPosiotn = [newChangeValue integerValue];
        ADKCameraPosition lensPosition;

        switch (originalLensPosiotn) {
            case AVCaptureDevicePositionUnspecified:
                lensPosition = ADKCameraPositionUnspecified;
                break;
            case AVCaptureDevicePositionFront:
                lensPosition = ADKCameraPositionFront;
                break;
            case AVCaptureDevicePositionBack:
                lensPosition = ADKCameraPositionRear;
                break;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:lensPositionChanged:)]) {
            [self.delegate ADKCamera:self lensPositionChanged:lensPosition];
        }
    }

    if (context == ExposureModeContext) {
        AVCaptureExposureMode originalExposureMode = [newChangeValue integerValue];
        ADKCameraExposureMode exposureMode;

        switch (originalExposureMode) {
            case AVCaptureExposureModeLocked:
                exposureMode = ADKCameraExposureModeLocked;
                break;
            case AVCaptureExposureModeAutoExpose:
                exposureMode = ADKCameraExposureModeAutoExposure;
                break;
            case AVCaptureExposureModeContinuousAutoExposure:
                exposureMode = ADKCameraExposureModeContinuousAutoExposure;
                break;
            default:
                // Not support in CameraKit
                exposureMode = NAN;
                break;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:exposureModeChanged:)]) {
            [self.delegate ADKCamera:self exposureModeChanged:exposureMode];
        }
    }

    if (context == ExposureDurationContext) {
        CMTime exposureDuration;
        [newChangeValue getValue:&exposureDuration];

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:exposureDurationChanged:)]) {
            [self.delegate ADKCamera:self exposureDurationChanged:exposureDuration];
        }
    }

    if (context == ISOContext) {
        CGFloat ISO = [newChangeValue floatValue];

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:ISOChanged:)]) {
            [self.delegate ADKCamera:self ISOChanged:ISO];
        }
    }

    if (context == ExposureTargetBiasContext) {
        CGFloat exposureTargetBias = [newChangeValue floatValue];

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:exposureTargetBiasChanged:)]) {
            [self.delegate ADKCamera:self exposureTargetBiasChanged:exposureTargetBias];
        }
    }

    if (context == ExposureTargetOffsetContext) {
        CGFloat exposureTargetOffset = [newChangeValue floatValue];

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:exposureTargetOffsetChanged:)]) {
            [self.delegate ADKCamera:self exposureTargetOffsetChanged:exposureTargetOffset];
        }
    }

    if (context == WhiteBalanceModeContext) {
        AVCaptureWhiteBalanceGains whiteBalanceGains;
        [newChangeValue getValue:&whiteBalanceGains];

        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:deviceWhiteBalanceGainsChanged:)]) {
            [self.delegate ADKCamera:self deviceWhiteBalanceGainsChanged:whiteBalanceGains];
        }
    }
    
    if (context == DeviceWhiteBalanceGainsContext) {
        AVCaptureWhiteBalanceGains deviceWhiteBalanceGains;
        [newChangeValue getValue:&deviceWhiteBalanceGains];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:deviceWhiteBalanceGainsChanged:)]) {
            [self.delegate ADKCamera:self deviceWhiteBalanceGainsChanged:deviceWhiteBalanceGains];
        }
    }
    
    if (context == SessionRunningContext) {
        BOOL sessionRunning = [newChangeValue isEqualToNumber:[NSNumber numberWithInt:1]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ADKCamera:sessionIsRunnig:)]) {
            [self.delegate ADKCamera:self sessionIsRunnig:sessionRunning];
        }
    }
}

@end
