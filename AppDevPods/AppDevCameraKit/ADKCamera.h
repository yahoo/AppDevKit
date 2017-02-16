//
//  ADKCamera.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 9/1/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, ADKCameraPosition) {
    ADKCameraPositionUnspecified = 0,
    ADKCameraPositionRear,
    ADKCameraPositionFront,
};

typedef NS_ENUM(NSInteger, ADKCameraFlashMode) {
    ADKCameraFlashModeOff = 0,
    ADKCameraFlashModeOn,
    ADKCameraFlashModeAuto,
};

typedef NS_ENUM(NSInteger, ADKCameraTorchMode) {
    ADKCameraTorchModeOff = 0,
    ADKCameraTorchModeOn,
};

typedef NS_ENUM(NSInteger, ADKCameraMirrorMode) {
    ADKCameraMirrorModeOff = 0,
    ADKCameraMirrorModeOn,
    ADKCameraMirrorModeAuto,
};

typedef NS_ENUM(NSInteger, ADKCameraFocusMode) {
    ADKCameraFocusModeLocked = 0,
    ADKCameraFocusModeAutoFocus,
    ADKCameraFocusModeContinuousAutoFocus,
};

typedef NS_ENUM(NSInteger, ADKCameraExposureMode) {
    ADKCameraExposureModeLocked = 0,
    ADKCameraExposureModeAutoExposure,
    ADKCameraExposureModeContinuousAutoExposure,
};

typedef NS_ENUM(NSInteger, ADKCameraWhiteBlanceMode) {
    ADKCameraWhiteBlanceModeLocked = 0,
    ADKCameraWhiteBlanceModeAutoWhiteBalance,
    ADKCameraWhiteBlanceModeContinuousAutoWhiteBalance,
};

extern NSString *const ADKCameraErrorDomain;
typedef NS_ENUM(NSInteger, ADKCameraErrorCode) {
    ADKCameraErrorCodeSession = 1,
    ADKCameraErrorCodeNotCamcoder,
    ADKCameraErrorCodeMovieRecording,
    ADKCameraErrorCodeFlashUnavailable,
    ADKCameraErrorCodeTorchUnabailable,
};


@interface ADKCamera : NSObject

/**
 * @brief The delegate instance for implement delegate methods. For example, you can use it to monitor focusing, exposuring, error handling and etc.
 */
@property (weak, nonatomic) id delegate;

/**
 * @brief This property is determined to align photo or video's orientation with device or UIViewController. If you want to align with device orientation but UIViewController wouldn't rotate the UI, you should set alignDeviceOrientation with YES.
 */
@property (assign, nonatomic) BOOL alignDeviceOrientation;

/**
 * @brief The camera quality of image output result. This values should be the same with sessionPreset in AVCaptureSession.
 */
@property (strong, readonly, nonatomic) NSString *cameraQuality;

/**
 * @brief The camera position you want to use. It might be front or rear camera on your device. Please refer ADKCameraPosition to set this value to ADKCamera. Default value will be ADKCameraPositionRear.
 */
@property (assign, nonatomic) ADKCameraPosition cameraPosition;

/**
 * @brief The flash mode you want to use. It might be on, off or auto on your device. Please refer ADKCameraFlashMode to set this value to ADKCamera. Default value will be ADKCameraFlashModeOff.
 */
@property (assign, nonatomic) ADKCameraFlashMode cameraFlashMode;

/**
 * @brief The torch mode you want to use. It might be on or off on your device. Please refer ADKCameraTorchMode to set this value to ADKCamera. Default value will be ADKCameraTorchModeOff.
 */
@property (assign, nonatomic) ADKCameraTorchMode cameraTorchMode;

/**
 * @brief The mirror mode you want to use. It can be control real-time preview view on captureVideoPreviewLayer when you're using front camera. It might be on, off or auto on your device. Please refer ADKCameraMirrorMode to set this value to ADKCamera. Default value will be ADKCameraMirrorModeAuto.
 */
@property (assign, nonatomic) ADKCameraMirrorMode cameraMirrorMode;

/**
 * @brief The focus mode you want to use. It might be locked, auto or continuous auto on your device. Please refer ADKCameraFocusMode to set this value to ADKCamera. Default value will be ADKCameraFocusModeAutoFocus.
 */
@property (assign, nonatomic) ADKCameraFocusMode cameraFocusMode;

/**
 * @brief The exposure mode you want to use. It might be locked, auto or continuous auto on your device. Please refer ADKCameraExposureMode to set this value to ADKCamera. Default value will be ADKCameraExposureModeAutoExposure.
 */
@property (assign, nonatomic) ADKCameraExposureMode cameraExposureMode;

/**
 * @brief The white balance mode you want to use. It might be locked, auto or continuous auto on your device. Please refer ADKCameraWhiteBlanceMode to set this value to ADKCamera. Default value will be ADKCameraWhiteBlanceModeAutoWhiteBalance.
 */
@property (assign, nonatomic) ADKCameraWhiteBlanceMode cameraWhiteBlanceMode;

/**
 * @brief The camera preview view with AVCaptureVideoPreviewLayer. It can preview real-time image from camera sensor. The preview might be mirror image if you turn on mirror mode by using cameraMirrorMode.
 */
@property (strong, readonly, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

/**
 * @brief It's camera recording status. If camera is recording video, it will return YES. Please notice the camera only can record one video simultaneously.
 */
@property (assign, readonly, nonatomic) BOOL recording;

/**
 * @brief The minimum value of exposure bias. Please keep exposure bias value bigger than this value.
 */
@property (assign, readonly, nonatomic) CGFloat minExposureBias;

/**
 * @brief The maximum value of exposure bias. Please keep exposure bias value less than this value.
 */
@property (assign, readonly, nonatomic) CGFloat maxExposureBias;

/**
 * @brief The current exposure bias setting on your camera. Bigger exposure bias will cause brighter image result otherwise lower exposure bias will get darker image result.
 */
@property (assign, nonatomic) CGFloat exposureBias;

/**
 * @brief The minimum value of shutter speed that current camera can support. Please keep shutter speed value bigger than this value.
 */
@property (assign, readonly, nonatomic) CGFloat minShutterSpeed;

/**
 * @brief The maximum value of shutter speed that current camera can support. Please keep shutter speed value less than this value.
 */
@property (assign, readonly, nonatomic) CGFloat maxShutterSpeed;

/**
 * @brief The current shutter speed setting on your camera. Bigger shutter speed will get clearer image result otherwise lower shutter speed will get blur image result.
 */
@property (assign, nonatomic) CGFloat shutterSpeed;

/**
 * @brief The minimum value of ISO that current camera can support. Please keep ISO value bigger than this value.
 */
@property (assign, readonly, nonatomic) CGFloat minISO;

/**
 * @brief The maximum value of ISO that current camera can support. Please keep ISO value less than this value.
 */
@property (assign, readonly, nonatomic) CGFloat maxISO;

/**
 * @brief The current ISO setting on your camera. Bigger ISO will get faster shutter speed otherwise lower ISO will get slower shutter speed.
 */
@property (assign, nonatomic) CGFloat ISO;

/**
 * @brief The minimum value of zoom factor that current camera can support. Please keep zoom factor value bigger than this value.
 */
@property (assign, readonly, nonatomic) CGFloat minZoomFactor;

/**
 * @brief The maximum value of zoom factor that current camera can support. Please keep zoom factor value less than this value.
 */
@property (assign, readonly, nonatomic) CGFloat maxZoomFactor;

/**
 * @brief The current zoom factor setting on your camera. Bigger zoom factor can get zoom in effect but blurer image result.
 */
@property (assign, nonatomic) CGFloat zoomFactor;

/**
 * @brief The minimum value of lens position that current camera can support. Please keep lens position value bigger than this value.
 */
@property (assign, readonly, nonatomic) CGFloat minLensPosition;

/**
 * @brief The maximum value of lens position that current camera can support. Please keep lens position value less than this value.
 */
@property (assign, readonly, nonatomic) CGFloat maxLensPosition;

/**
 * @brief The current lens position setting on your camera. Lower lens position can reach closer focus otherwise higher lend position can reach farer focus.
 */
@property (assign, nonatomic) CGFloat lensPosition;

/**
 * @brief The minimum value of white balance temperature that current camera can support. Please keep white balance temperature value bigger than this value.
 */
@property (assign, readonly, nonatomic) CGFloat minWhiteBalanceTemperature;

/**
 * @brief The maximum value of white balance temperature that current camera can support. Please keep white balance temperature value less than this value.
 */
@property (assign, readonly, nonatomic) CGFloat maxWhiteBalanceTemperature;

/**
 * @brief The current white balance temperature setting on your camera. The white balance color correlated temperature in kelvin. This property will effect color of final image result.
 */
@property (assign, nonatomic) CGFloat whiteBalanceTemperature;

/**
 * @brief The minimum value of white balance tint that current camera can support. Please keep white balance tint value bigger than this value.
 */
@property (assign, readonly, nonatomic) CGFloat minWhiteBalanceTint;

/**
 * @brief The maximum value of white balance tint that current camera can support. Please keep white balance tint value less than this value.
 */
@property (assign, readonly, nonatomic) CGFloat maxWhiteBalanceTint;

/**
 * @brief The current white balance tint setting on your camera. This property will effect strength of white balance temperature.
 */
@property (assign, nonatomic) CGFloat whiteBalanceTint;

/**
 * @brief Enable or disable low light boost mechanism on your camera. When you assign YES value into this property, it means you want to enable this feature.
 */
@property (assign, nonatomic) BOOL lowLightBoost;

/**
 * @brief Enable or disable stabilization mechanism on your camera. When you assign YES value into this property, it means you want to enable this feature.
 */
@property (assign, nonatomic) BOOL stabilization;


/**
 * @brief Getting status of camera permission. If it return YES means user already approved camera permission that you have permission to use their camera. When it return NO, please handle permission request process by yourself.
 *
 * @return Camera permission status in BOOL value.
 */
+ (BOOL)cameraPermission;

/**
 * @brief Getting status of microphone permission. If it return YES means user already approved microphone permission that you have permission to use their microphone. When it return NO, please handle permission request process by yourself.
 *
 * @return Microphone permission status in BOOL value.
 */
+ (BOOL)microphonePermission;

/**
 * @brief Checking for capability of using front camera. If it return YES means current device has this sensor and you can use it. When it return NO, it means current device might be not exist or have no capability to use it.
 *
 * @return Front camera available status in BOOL value.
 */
+ (BOOL)frontCameraAvailable;

/**
 * @brief Checking for capability of using rear camera. If it return YES means current device has this sensor and you can use it. When it return NO, it means current device might be not exist or have no capability to use it.
 *
 * @return Rear camera available status in BOOL value.
 */
+ (BOOL)rearCameraAvailable;

/**
 * @brief Initializing a camera instance for shooting photos. Please set your required settings at the beginning.
 *
 * @param delegate Assigning a delegate target to handle camera's response. Please refer ADKCameraDelegate protocol to know what methods you can implement.
 * @param cameraQuality Assigning camera quality in camera instance. This values should be the same with sessionPreset in AVCaptureSession.
 * @param cameraPosition Assigning camera position in ADKCameraPosition. It will help you to set up first camera sensor for you.
 *
 * @return Instance of ADKCamera that you can use it to make your own customized camera feature. (Making photo only)
 */
- (instancetype)initCameraWithDelegate:(id)delegate quality:(NSString *)cameraQuality position:(ADKCameraPosition)cameraPosition;

/**
 * @brief Initializing a camera instance for shooting photos and recording video simultaneously. Please set your required settings at the beginning.
 *
 * @param delegate Assigning a delegate target to handle camera's response. Please refer ADKCameraDelegate protocol to know what methods you can implement.
 * @param cameraQuality Assigning camera quality in camera instance. This values should be the same with sessionPreset in AVCaptureSession.
 * @param cameraPosition Assigning camera position in ADKCameraPosition. It will help you to set up first camera sensor for you.
 *
 * @return Instance of ADKCamera that you can use it to make your own customized camera feature.
 */
- (instancetype)initCamcoderWithDelegate:(id)delegate quality:(NSString *)cameraQuality position:(ADKCameraPosition)cameraPosition;

/**
 * @brief Optimizing camera for getting highest frame rate. If you want to get the fastest camera response, you can use this method to achieve your purpose.
 */
- (void)optimizeForHighestFrameRate;

/**
 * @brief Checking for capability of using flash feature on your camera. If it return YES means current device has this sensor and you can use it. When it return NO, it means current device might be not exist or have no capability to use it.
 *
 * @return Flash available status in BOOL value.
 */
- (BOOL)flashAvailable;

/**
 * @brief Checking for capability of using torch feature on your camera. If it return YES means current device has this sensor and you can use it. When it return NO, it means current device might be not exist or have no capability to use it.
 *
 * @return Torch available status in BOOL value.
 */
- (BOOL)torchAvailable;

/**
 * @brief Using camera to take focus on your target. The focus point's format should be CGPoint.
 *
 * @param focusPoint Assigning a CGPoint to make a focus point on your camera. The value should between (0, 0) and (1, 1). If you want to convert screen coordiniate into required coordinate, the captureDevicePointOfInterestForPointmethodin AVCaptureVideoPreviewLayer can satisfy your requirement.
 */
- (void)focusAtPoint:(CGPoint)focusPoint;

/**
 * @brief Using camera to take exposure on your target. The exposure point's format should be CGPoint.
 *
 * @param exposurePoint Assigning a CGPoint to make a exposure point on your camera. The value should between (0, 0) and (1, 1). If you want to convert screen coordiniate into required coordinate, the captureDevicePointOfInterestForPointmethodin AVCaptureVideoPreviewLayer can satisfy your requirement.
 */
- (void)exposureAtPoint:(CGPoint)exposurePoint;

/**
 * @brief Asking camera to start it's mechanism for shooting photos or recording videos. For performance issue, I suggest you should stop camera when you don't need it and recover it by calling startCamera method. For example, presenting modal view to cover camera view, pushing app to background , transferring  into other view and etc.
 */
- (void)startCamera;

/**
 * @brief Asking camera to stop it's mechanism for shooting photos or recording videos. For performance issue, I suggest you should stop camera when you don't need it and recover it by calling startCamera method. For example, presenting modal view to cover camera view, pushing app to background , transferring  into other view and etc.
 */
- (void)stopCamera;

/**
 * @brief
 *
 * @param completionBlock
 */
- (void)captureImage:(void (^)(UIImage *image, NSDictionary *exifDic, NSError *error))completionBlock;

/**
 * @brief Asking camera start to make video recording. The error handler and response handler will be satisfy in this method.
 *
 * @param completionBlock The block that you handle error and response  behavior. If error parameter is not nil, it means something wrong when you record. Please read error code to understand what happen to it. It also return videoOutputURL to tell you where video recording file is.
 * @param videoOutputURL Assigning a video output url with NSURL data type. The camera will record video and save it to this url path.
 */
- (void)startCaptureVideo:(void (^)(NSURL *videoOutputURL, NSError *error))completionBlock outputURL:(NSURL *)videoOutputURL;

/**
 * @brief Asking camera to terminate video recording. After you stop capture video, you could get a video file url that camera recorded.
 */
- (void)stopCaptureVideo;

@end


@protocol ADKCameraDelegate <NSObject>

@optional
- (void)ADKCamera:(ADKCamera *)camera focusIsAdjusting:(BOOL)adjusting;
- (void)ADKCamera:(ADKCamera *)camera exposureIsAdjusting:(BOOL)adjusting;
- (void)ADKCamera:(ADKCamera *)camera whiteBalanceIsAdjusting:(BOOL)adjusting;
- (void)ADKCamera:(ADKCamera *)camera sessionIsRunnig:(BOOL)running;
- (void)ADKCamera:(ADKCamera *)camera focusModeChanged:(ADKCameraFocusMode)focusMode;
- (void)ADKCamera:(ADKCamera *)camera lensPositionChanged:(ADKCameraPosition)lensPosition;
- (void)ADKCamera:(ADKCamera *)camera exposureModeChanged:(ADKCameraExposureMode)exposureMode;
- (void)ADKCamera:(ADKCamera *)camera exposureDurationChanged:(CMTime)exposureDuration;
- (void)ADKCamera:(ADKCamera *)camera ISOChanged:(CGFloat)ISO;
- (void)ADKCamera:(ADKCamera *)camera exposureTargetBiasChanged:(CGFloat)exposureTargetBias;
- (void)ADKCamera:(ADKCamera *)camera exposureTargetOffsetChanged:(CGFloat)exposureTargetOffset;
- (void)ADKCamera:(ADKCamera *)camera whiteBalanceModeChanged:(ADKCameraWhiteBlanceMode)whiteBalanceMode;
- (void)ADKCamera:(ADKCamera *)camera deviceWhiteBalanceGainsChanged:(AVCaptureWhiteBalanceGains)deviceWhiteBalanceGains;
- (void)ADKCamera:(ADKCamera *)camera didFailWithError:(NSError *)error;
@end
