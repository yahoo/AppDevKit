# Change Log
All notable changes to this project will be documented in this file.
`AppDevKit` adheres to [Semantic Versioning](http://semver.org/).

## 1.6.0
#### Added
* Adding a new ADKMetalImageView to support Metal framework. It can be used for CIImage instance and render view very fast with GUP clips.
* Adding ADKHexString compatible of UIColor to support different HEX color formate. EX: 0xFFAA33 and FFAA33.
* Adding the UIColor support for extended SRGB color space.
#### Fixed
* Fixing the issues that ADKGradientView and ADKMultiGradientView won't display gradient color correctly when setting color contains transparent alpha channel.
* Fixing the crash issue when PullToRefresh and InfiniteScrolling are using in the same UIScrollView. It would miss the paired removeObserver: method call.

## 1.5.0
#### Added
* Adding a new gradient view generator that can creat a complicated gradient effect with multiple colors and locations.
* Adding a new method to support redraw feature in ADKGradientView. 

## 1.4.0
#### Added
* Adding a new method to support manual update layout in UIScrollView+ADKInfiniteScrollingView. It allows you to modify scroll view's offset dynamically. 

## 1.3.1
#### Fixed
* Revert prepareForReuse: method call in ADKCellDynamicSizeCalculator.

## 1.3.0
#### Fixed
* fixing some bugs in ADKNibCacheManager, ADKCellDynamicSizeCalculator and etc.

#### Added 
* Adding ADKOpenGLImageView to provides OpenGL rendering solution for CameraKit.
* Adding color transfer methods for ARGB, GBRA in UIColor.

## 1.2.2
#### Fixed
* Fix Pull-To-Refresh on iOS11. Pull-to-refresh triggers reloading immediately even pulling down for a very short distance then releasing on iOS 11. We fixed this problem in this version.

## 1.2.1
#### Fixed
* Fixing the problem of image results with wrong mirror mode. It might be triggerd after users flip camera lens from rear to front or front to rear.  

## 1.2.0
#### Added
* Extending CameraKit to support live video data feature. When using CameraKit to implement a camera, CameraKit has the capability that allows you to do the real-time image analysis.   

## 1.1.1
#### Added
* Adding a sample to demo how to use CameraKit to initialize a camera app.
#### Fixed
* Fix logic error in UIView+ADKAutoLayoutSupport.   

## 1.1.0
#### Added
* Adding a new CameraKit for providing several high level camera control APIs. It allows you control camera features that contain focus, exposure, shutter duration, white blance and etc and can be used manually.    

## 1.0.3
#### Added
* Version check for iOS 10
* Wide screen check (Reconize device wider than 320 as wide screen)
#### Fixed
* Fix load wrong bundle when SDK embed AppDevKit
* Fix image scale detect

## 1.0.2
#### Fixed
* Fixing wrong spelling in ADKGradientView.
* Fix ADKIsLongerScreen logic

#### Updated
* Updateing readme description for sub-pod and tutorial materials.
* Refine project settings

## 1.0.1
#### Added
* Adding Change log.
#### Fixed
* Refining UIImage+ADKImageFilter and fix bug in ADKGaussianBlurWithRadius.
#### Updated
* Updating readme description, badge.

## 1.0.0
* Making first release for AppDevKit.
