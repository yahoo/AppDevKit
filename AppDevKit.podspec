Pod::Spec.new do |s|

  s.name         = "AppDevKit"
  s.version      = "1.7.1"
  s.summary      = "The collection of open develop utilities for iOS development team. It contains foundational and useful features that Apple didn't provide."
  s.homepage     = "https://github.com/yahoo/AppDevKit"
  s.license      = "Yahoo! Inc. BSD license"

  s.author       = { "anistar sung" => "cfsung@yahooinc.com", "core team" => "app-dev-kit@yahooinc.com" }
  s.platform     = :ios, "10.0"
  s.ios.deployment_target = '10.0'

  s.subspec 'AppDevCommonKit' do |appDevCommonKit|
      appDevCommonKit.source_files = ['AppDevPods/AppDevCommonKit/**/*', 'AppDevPods/AppDevCommonKit.h']
      appDevCommonKit.public_header_files = ['AppDevPods/AppDevCommonKit/**/*.h', 'AppDevPods/AppDevCommonKit.h']
  end

  s.subspec 'AppDevUIKit' do |appDevUIKit|
      appDevUIKit.source_files = ['AppDevPods/AppDevUIKit/**/*', 'AppDevPods/AppDevUIKit.h']
      appDevUIKit.public_header_files = ['AppDevPods/AppDevUIKit/**/*.h', 'AppDevPods/AppDevUIKit.h']
      appDevUIKit.dependency 'AppDevKit/AppDevCommonKit'
  end

  s.subspec 'AppDevAnimateKit' do |appDevAnimateKit|
      appDevAnimateKit.source_files = ['AppDevPods/AppDevAnimateKit/**/*', 'AppDevPods/AppDevAnimateKit.h']
      appDevAnimateKit.public_header_files = ['AppDevPods/AppDevAnimateKit/**/*.h', 'AppDevPods/AppDevAnimateKit.h']
  end

  s.subspec 'AppDevImageKit' do |appDevImageKit|
      appDevImageKit.source_files = ['AppDevPods/AppDevImageKit/**/*', 'AppDevPods/AppDevImageKit.h']
      appDevImageKit.public_header_files = ['AppDevPods/AppDevImageKit/**/*.h', 'AppDevPods/AppDevImageKit.h']
      appDevImageKit.dependency 'AppDevKit/AppDevCommonKit'
  end

  s.subspec 'AppDevListViewKit' do |appDevListViewKit|
      appDevListViewKit.source_files = ['AppDevPods/AppDevListViewKit/**/*', 'AppDevPods/AppDevListViewKit.h']
      appDevListViewKit.public_header_files = ['AppDevPods/AppDevListViewKit/**/*.h', 'AppDevPods/AppDevListViewKit.h']
      appDevListViewKit.dependency 'AppDevKit/AppDevCommonKit'
      appDevListViewKit.dependency 'AppDevKit/AppDevUIKit'
  end

  s.subspec 'AppDevCameraKit' do |appDevCameraKit|
      appDevCameraKit.source_files = ['AppDevPods/AppDevCameraKit/**/*', 'AppDevPods/AppDevCameraKit.h']
      appDevCameraKit.public_header_files = ['AppDevPods/AppDevCameraKit/**/*.h', 'AppDevPods/AppDevCameraKit.h']
  end

  s.source = { :git => "https://github.com/yahoo/AppDevKit.git", :tag => s.version.to_s }
  s.source_files = "AppDevPods/AppDevKit.h"
  s.public_header_files = "AppDevPods/AppDevKit.h"
  s.requires_arc = true

end
