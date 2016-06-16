# AppDevKit
[![Build Status](https://travis-ci.org/yahoo/AppDevKit.svg?branch=master)](https://travis-ci.org/yahoo/AppDevKit) 
[![codecov](https://codecov.io/gh/yahoo/AppDevKit/branch/master/graph/badge.svg)](https://codecov.io/gh/yahoo/AppDevKit)
[![CocoaPods](https://img.shields.io/cocoapods/v/AppDevKit.svg?maxAge=2592000?style=flat-square)](https://github.com/yahoo/AppDevKit)

AppDevKit is an iOS development library that provides fundamental and useful features to help your iOS app development. This kit has used by Yahoo’s iOS app development team in Taiwan for the past 3 years, and we plan on having future outsourced apps use AppDevKit too. Our use of this code in many production environments helped improve its stability and scalability. We find these libraries make difficult development tasks easier and has saved us up to 30% development time in some cases. The kit also helps address some incompatibility issues found in different iOS versionss.

AppDevKit has 5 major parts. These are: command, user interfaces, animation, image, and list view support libraries. Please feel welcome to use AppDevKit in your iOS projects and help contribute improvements to too.

If you have suggestions about how to improve this project, please feel free to contact (**cfsung@yahoo-inc.com**) and core development team (**app-dev-kit@yahoo-inc.com**) or send a **pull request** to this project. Thank you. 

<img src="img/AppDevKitSticker.jpg">

## Usage

### Installation with CocoaPods

The easiest way to leverage AppDevKit is using CocoaPods. Please edit your **Podfile** like this:

<pre>
source 'https://github.com/CocoaPods/Specs.git'  

pod 'AppDevKit'
</pre>

### Basic Usage
  
  Using this develop kit is very simple. First at all, import it in your any code file or just put it in prefix file (.pch). 
  
    #import <AppDevKit.h>

### Common Tools

  - **ADKAppUtil** > The foundational tools to support common tasks.
  - **ADKStringHelper** > The string formatter that will generate formatted stings form date, number and etc for you.
  - **ADKCalculatorHelper** > The calculation set including distance, size, width, height, etc.
  - **ADKNibCacheManager** > The manager to cache different instances in memory and keep it as a singleton.
  - **UIView+ADKGetUIViewController** > Supports get any view's UIViewController.
  - **UIColor+ADKHexPresentation** > Supports HEX color format and color shift.
  - **ADKViewExclusiveTouch** > Supports exclusive touch on each sub views.


### UI Tools

  - **UIView+ADKAutoLayoutSupport** > Supports command autolayout features.
  - **UIScrollView+ADKPullToRefreshView** > Supports pull to refresh feature on scrollable view. For example: UIScrollView, UITableView and UICollectionView.
  - **UIScrollView+ADKInfiniteScrollingView** > Supports infinite scrolling feature on scrollable view. For example: UIScrollView, UITableView and UICollectionView.
  - **ADKModalMaskView** > Providing a way to create a modal view for presenting specific view.
  - **ADKGradientView** > Creates a gradient view for you.
  - **ADKDashedLineView** > Creates a dashed line around your view.


### Animation Tools
  - **UIView+ADKAnimationMacro** > Gives some simple animation behavior for specific UIView.
  

### Image Tools

  - **UIImage+ADKColorReplacement** > Supports color changing / replacement feature on UIImage.
  - **UIImage+ADKImageFilter** > Supports image FX, resize, crop, etc. on UIImage.
  - **UIImage+ADKDrawingTemplate** > Supports loss less image from a PDF source.


### ListView Tools
  
  - **UICollectionView+ADKOperation** > Supports force stop scrolling in collection view.
  - **ADKNibSizeCalculator** > Provides correct cell size for different devices effectively.
  - **ADKCellDynamicSizeCalculator** > Calculates dynamic cell with and height for UICollectionViewCell and UITableViewCell.
  - **ADKCollectionViewDynamicSizeCell** > Base UICollectionViewCell supports dynamic width and height features.
  - **ADKTableViewDynamicSizeCell** > Base UITableViewCell supports dynamic width and height features.

### Instruction

  - **Introduction of AppDevKit** > http://www.slideshare.net/anistarsung/appdevkit-for-ios-development
  - **Presenting YDevelopKit (AppDevKit) in YMDC 2016** > https://youtu.be/I9QDYDGcn8M
  - **Sample Codes** has been written in AppDevKit project. You can read code to know about "How to implement these features in your project". Just use git to clone AppDevKit to your local disk. It should run well with your XCode. 
  - **API Reference Documents** > Please refer the [gh-pages](https://yahoo.github.io/AppDevKit/) in AppDevKit project.
  <img width="100%" src="img/DocScreenShot.png">

### License

This software is free to use under the BSD open source license.
See the [LICENSE] for license text and copyright information.

[LICENSE]: https://github.com/yahoo/AppDevKit/blob/master/LICENSE.md
