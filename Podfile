platform :ios, '13.0'
inhibit_all_warnings!

target 'Commute' do
  use_frameworks!
  
  pod 'TfNSW', :git => 'https://github.com/themuzzleflare/TfNSW.git'
  pod 'SwiftProtobuf'
  pod 'SwiftLint'
  pod 'SwiftDate'
  pod 'Alamofire'
  pod 'AlamofireNetworkActivityIndicator'
  pod 'BonMot'
  pod 'SnapKit'
  pod 'Texture'
  pod 'Texture/IGListKit'
  pod 'MBProgressHUD'
  pod 'MapboxMaps'
  pod 'MarqueeLabel'
  pod 'Firebase/AnalyticsWithoutAdIdSupport'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/AppCheck'
  
end

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Commute/Pods-Commute-acknowledgements.plist', 'Commute/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
  installer.pods_project.targets.each do |target|
    if target.name == 'PINCache' || target.name == 'PINOperation' || target.name == 'PINRemoteImage' || target.name == 'IGListKit' || target.name == 'MBProgressHUD'
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    else
      if target.name == 'Texture'
        target.build_configurations.each do |config|
          config.build_settings['VALIDATE_WORKSPACE_SKIPPED_SDK_FRAMEWORKS'] = 'AssetsLibrary'
        end
      end
    end
  end
end