# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!

def available_pods
  pod 'Alamofire', '~>5.9.0'
  pod 'THLabel', '~> 1.4.0'
  pod 'DBDebugToolkit'
  pod 'SDWebImage', '~>5.19.5'
  pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
  pod 'AcknowList'
  pod 'FirebaseAuth'
  pod 'FirebaseCore'
  pod 'GoogleSignIn'
  pod 'FacebookLogin'
  pod 'atlantis-proxyman'
  pod 'SnapKit', '~> 5.7.0'
end

target 'Movies-App [DEV]' do
  available_pods
end

target 'Movies-App [DEV-ST]' do
  available_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
        end
    end
end
