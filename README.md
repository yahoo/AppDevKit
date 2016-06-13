AppDevKit
============
[![Build Status](https://travis-ci.org/yahoo/AppDevKit.svg?branch=master)](https://travis-ci.org/yahoo/AppDevKit)

AppDevKit is an iOS development library that provides foundational and developer everyday required features for their iOS app development. It has been using in Yahoo’s iOS app productions for 3 years and future outsourcing apps will use AppDevKit as well. The stability and scalability has been verified on these production app. It makes difficult development easer and save 30% development time in real case. It also cover incompatible issues on different iOS platform.

It has 5 major parts that include command, user interfaces, animate, image and list view support libraries. Please leverage AppDevKit in your iOS project or join our development group of AppDevKit. We will maintain this project for you.

If you have any idea to improve this project, please feel free to contact with me (**cfsung@yahoo-inc.com**) and core team (**y-develop-kit@yahoo-inc.com**) or send **Pull Request** to us. Thank you. 

<img src="img/AppDevKitSticker.jpg">

## Usage

### Installation with CocoaPods

The easiest way to leverage AppDevKit is using cocoaPods. Please edit your **Podfile** like this:

<pre>
source 'https://github.com/CocoaPods/Specs.git'  

pod 'AppDevKit'
</pre>

### Basic Usage
  
  Using this develop kit is very simple. First at all, import it in your any code file or just put it in prefix file (.pch). Then you will enjoy this develop kit. 
  
    #import <AppDevKit.h>

### Common Tools

  - **ADKAppUtil** > The foundational tools to support common tasks.
  - **ADKStringHelper** > The string formatter that it generate formatted stings form date, number and etc for you.
  - **ADKCalculatorHelper** > The calculation set include distance, size, width, height and etc.
  - **ADKNibCacheManager** > The manager to cache different instances in memory and keep it singleton.
  - **UIView+ADKGetUIViewController** > Support get any view's UIViewController.
  - **UIColor+ADKHexPresentation** > Supporting HEX color format and color shift.
  - **ADKViewExclusiveTouch** > Supporting exclusive touch on each sub views.


### UI Tools

  - **UIView+ADKAutoLayoutSupport** > Supporting command autolayout features.
  - **UIScrollView+ADKPullToRefreshView** > Supporting pull to refresh feature on scrollable view. For example: UIScrollView, UITableView and UICollectionView.
  - **UIScrollView+ADKInfiniteScrollingView** > Supporting infinite scrolling feature on scrollable view. For example: UIScrollView, UITableView and UICollectionView.
  - **ADKModalMaskView** > Providing a way to create a modal view for presenting specific view.
  - **ADKGradientView** > Create a gradient view for you.
  - **ADKDashedLineView** > Create a dashed line around your view.


### Animate Tools
  - **UIView+ADKAnimationMacro** > Giving some simple animations behavior for specific UIView.
  

### Image Tools

  - **UIImage+ADKColorReplacement** > Supporting color changing / replacement feature on UIImage.
  - **UIImage+ADKImageFilter** > Supporting image FX, resize, crop and etc on UIImage.
  - **UIImage+ADKDrawingTemplate** > Supporting loss less image from a PDF source.


### ListView Tools
  
  - **UICollectionView+ADKOperation** > Supporting force stop scrolling in collection view.
  - **ADKNibSizeCalculator** > Providing correct cell size for different devices effectively.
  - **ADKCellDynamicSizeCalculator** > Calculation dynamic cell with and height for UICollectionViewCell and UITableViewCell.
  - **ADKCollectionViewDynamicSizeCell** > Base UICollectionViewCell supports dynamic width and height features.
  - **ADKTableViewDynamicSizeCell** > Base UITableViewCell supports dynamic width and height features.

### Instruction

  - **Introduction of YDevelopKit** > https://drive.google.com/a/yahoo-inc.com/file/d/0B4rg-DXSff5VWGxwNHVIOGltclE/view?usp=sharing  (AppDevKit's previous version is YDevelopKit)
  - **Quickstart of YDevelopKit** > https://drive.google.com/a/yahoo-inc.com/file/d/0B4rg-DXSff5VZDJ1amRMWmpGaHM/view?usp=sharing
  - **Sample Codes** has been written in AppDevKit project. You can read code to know about "How to implement these features in your project". Just use git to clone AppDevKit to your local disk. It should run well with your XCode. 
  - **API Reference Documents** > Please refer the [gh-pages](https://yahoo.github.io/AppDevKit/) in AppDevKit project. (Doc/index.html)
  <img width="100%" src="img/DocScreenShot.png">

### License

This software is free to use under the Yahoo! Inc. BSD license.
See the [LICENSE] for license text and copyright information.

[LICENSE]: https://github.com/yahoo/AppDevKit/blob/master/LICENSE.md
