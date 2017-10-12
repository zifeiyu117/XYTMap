# Uncomment the next line to define a global platform for your project

source 'https://git.coding.net/heyutao117/XYTFMSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

target 'XYTOfo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod "SWRevealViewController"
  pod "AMap3DMap"
  pod "AMapLocation"
  pod "AMapNavi"
  pod "FTIndicator"
  pod "AMapSearch"
  pod "swiftScan"
  pod "Alamofire"
  pod "XYTNavigationBar"
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
