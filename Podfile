# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Movies-App' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Movies-App
  pod 'Alamofire', '~>5.9.0'
  pod 'Kingfisher', '~>7.10.0'
  pod 'THLabel', '~> 1.4.0'
  pod 'DBDebugToolkit'
  pod 'SDWebImage', '~>5.19.5'
  pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
  pod 'AcknowList'
  pod 'FirebaseAuth'
  pod 'FirebaseCore'
  pod 'GoogleSignIn'
  pod 'FacebookLogin'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
        end
    end
end
