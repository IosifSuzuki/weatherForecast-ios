# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

def swinject_pods
  pod 'Swinject', '~> 2.0'
  pod 'SwinjectAutoregistration', '~> 2.8'
end

def rxswift_pods
  pod 'RxSwift', '~> 6.5.0'
  pod 'RxCocoa', '~> 6.5.0'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D',
          'TRACE_RESOURCES']
        end
      end
    end
  end
end

target 'Weather-Forecast' do

#use_frameworks!

# Pods for Weather Forecast

swinject_pods
rxswift_pods

pod 'Kingfisher', '~> 7.0'

end
