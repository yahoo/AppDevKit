Pod::Spec.new do |s|

  s.name         = "YDevelopKit"
  s.version      = "2.1.0"
  s.summary      = "The collection of open develop utilities for iOS development team. It contains foundationl and useful features that Apple didn't provide."

  s.description  = <<-DESC
  2.1.0 (16.Dec.2015)
    - Refator YDKAppUtil's methods for avoiding naming conflict.
    - Adding 2 methods to measure screen ratio and screen size with portrait orientation.
  2.0.0 (8.Dec.2015)
    - Add prefix "YDK" to all related Classes and enumeration
    - Support individual import:YDevelopCommandKit.h, YDevelopUIKit.h, YDevelopAnimateKit.h, YDevelopImageKit.h, YDevelopListViewKit.h
    - Use NSCache for YDKCacheManager(Nib, drawn image, and sample cell cache)
    - UIView+YDKAutoLayoutSupport supports bulk constraint operations, and bug fix
    - Improve UIImage+YDKColorReplacement and caches drawn image
    - UIScrollView+YDKPullToRefreshView, UIScrollView+YDKInfiniteScrollingView support new dragging status, drag range, and fix bugs
  1.0.0 (1.Sep.2015)
    - Improve StringHelper Add more type format to format your string.
    - Fix GradientView initialized issue. 
  0.0.3 (9.June.2015)
    - New AppUtil The foudational tools to suppport comon tasks.
    - New StringHelper The string formatter that it genarate formatted stings form date, number and etc for you.
    - New CalculatorHelper The calculation set include distance, size, width, height and etc.
    - New CacheManager The manager to cache diffrent instances in memory and keep it singleton.
    - New NibSizeCalculator Providing correct cell size for diffent devices effectionly.
    - New CellDynamicHeightCalculator Calculation dynamic cell height for UICollectionViewCell and UITableViewCell.
    - New UICollectionViewDynamicHeightCell The base UICollectionViewCell for supporting dynamic height cell.
    - New UITableViewDynamicHeightCell The base UITableViewCell for supporting dynamic height cell.
    - New UIImage+DrawingTemplate Supporting loss less image from a PDF source.
    - New UICollectionView+Operation Supporting force stop scrolling in collection view.
    - New UIColor+HexPresentation Supporting HEX color format and color shift.
    - New UIView+AutoLayoutSupport Supporting command autolayout features.
    - New UIView+AnimationMacro Giving some simple animations behavior for specific UIView.
    - New UIScrollView+PullToRefreshView Supporting pull to refresh featue on scrollable view. For exmaple: UIScrollView, UITableView and UICollectionView.
    - New UIScrollView+InfiniteScrollingView Supporting infinited scrolling featue on scrollable view. For exmaple: UIScrollView, UITableView and UICollectionView.
    - New ViewExclusiveTouch Supporting exclusiving touch on each sub views.
    - New ModalMaskView Providing a way to create a modal view for presentaing specific view.
    - New GradientView Create a gradiented view for you.
    - New DashedLineView Cteate a dashed linf around your view.
  0.0.2 (15.May.2015)
    - New UIImage+ColorReplacement category for support UIImage color process.
    - New UIImage+ImageFilter category for support UIImage FX process.
  0.0.1 (14.May.2015)
    - New NSURL+ECStoreAddition category for support SSL connection.
    - New UICollectionView+Operation for support force stop scrolling in collection view.
    - New UIColor+HexPresentation for support HEX color format and color shift.
    - New UIView+AutoLayoutSupport support autolayout features.
    - New UIView+UIViewController support get any view's UIViewController.
                   DESC

  s.homepage     = "https://git.corp.yahoo.com/EC-Mobile/YDevelopKit"
  s.license      = { :type => 'Yahoo Internal', :text => 'YAHOO! CONFIDENTIAL & INTERNAL ONLY' }
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  s.author             = { "anistar sung" => "cfsung@yahoo-inc.com" }
  s.social_media_url   = "https://backyard.yahoo.com/profile/index.php?userid=cfsung"

  s.platform     = :ios, "7.0"

  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"

  s.subspec 'YDevelopCommonKit' do |yDevelopCommonKit|
      yDevelopCommonKit.source_files = ['YDevelopKitPods/YDevelopCommonKit/**/*', 'YDevelopKitPods/YDevelopCommonKit.h']
      yDevelopCommonKit.public_header_files = ['YDevelopKitPods/YDevelopCommonKit/**/*.h', 'YDevelopKitPods/YDevelopCommonKit.h']
  # yDevelopCommonKit.dependency '', ''
  end


  s.subspec 'YDevelopUIKit' do |yDevelopUIKit|
      yDevelopUIKit.source_files = ['YDevelopKitPods/YDevelopUIKit/**/*', 'YDevelopKitPods/YDevelopUIKit.h']
      yDevelopUIKit.public_header_files = ['YDevelopKitPods/YDevelopUIKit/**/*.h', 'YDevelopKitPods/YDevelopUIKit.h']
      yDevelopUIKit.dependency 'YDevelopKit/YDevelopCommonKit'
  end

  s.subspec 'YDevelopAnimateKit' do |yDevelopAnimateKit|
      yDevelopAnimateKit.source_files = ['YDevelopKitPods/YDevelopAnimateKit/**/*', 'YDevelopKitPods/YDevelopAnimateKit.h']
      yDevelopAnimateKit.public_header_files = ['YDevelopKitPods/YDevelopAnimateKit/**/*.h', 'YDevelopKitPods/YDevelopAnimateKit.h']
  # yDevelopAnimateKit.dependency '', ''
  end

  s.subspec 'YDevelopImageKit' do |yDevelopImageKit|
      yDevelopImageKit.source_files = ['YDevelopKitPods/YDevelopImageKit/**/*', 'YDevelopKitPods/YDevelopImageKit.h']
      yDevelopImageKit.public_header_files = ['YDevelopKitPods/YDevelopImageKit/**/*.h', 'YDevelopKitPods/YDevelopImageKit.h']
      yDevelopImageKit.dependency 'Ymagine', '~> 0.7.3'
      yDevelopImageKit.dependency 'YDevelopKit/YDevelopCommonKit'
  end

  s.subspec 'YDevelopListViewKit' do |yDevelopListViewKit|
      yDevelopListViewKit.source_files = ['YDevelopKitPods/YDevelopListViewKit/**/*', 'YDevelopKitPods/YDevelopListViewKit.h']
      yDevelopListViewKit.public_header_files = ['YDevelopKitPods/YDevelopListViewKit/**/*.h', 'YDevelopKitPods/YDevelopListViewKit.h']
      yDevelopListViewKit.dependency 'YDevelopKit/YDevelopCommonKit'
      yDevelopListViewKit.dependency 'YDevelopKit/YDevelopUIKit'
  end

  s.source = { :git => "git@git.corp.yahoo.com:EC-Mobile/YDevelopKit.git", :tag => s.version.to_s }
  s.source_files = "YDevelopKitPods/YDevelopKit.h"
  s.public_header_files = "YDevelopKitPods/YDevelopKit.h"
  # s.exclude_files = "Classes/Exclude"
  s.requires_arc = true

  # s.dependency "YDevelopKit/YDevelopCommonKit"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
