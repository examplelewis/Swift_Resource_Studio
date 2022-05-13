# Uncomment this line to define a global platform for your project
platform :osx, '10.15'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Resource Studio' do
	pod 'Alamofire'
	pod 'CocoaLumberjack/Swift'
	pod 'DateTools'
	pod 'FMDB'
	pod 'HandyJSON'
	pod 'SDWebImage'
	pod 'SnapKit'
  
  pod 'hpple'
end

# 以下内容用于解决编译警告: The macOS deployment target 'MACOSX_DEPLOYMENT_TARGET' is set to 10.7, but the range of supported deployment target versions is 10.9 to 12.3.99.
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15'
    end
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15'
        end
    end
end
