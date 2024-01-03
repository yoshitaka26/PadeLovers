# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

target 'PadeLovers' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PadeLovers
  pod 'SwiftLint'
  pod 'RxSwift', '~> 6.5.0'
  pod 'RxCocoa', '~> 6.5.0'
  
  target 'PadeLoversTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
    # Get main project development team id
    dev_team = ""
    project = installer.aggregate_targets[0].user_project
    project.targets.each do |target|
        target.build_configurations.each do |config|
            if dev_team.empty? and !config.build_settings['DEVELOPMENT_TEAM'].nil?
                dev_team = config.build_settings['DEVELOPMENT_TEAM']
            end
        end
    end

    # Fix bundle targets' 'Signing Certificate' to 'Sign to Run Locally'
    installer.pods_project.targets.each do |target|
        if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
            target.build_configurations.each do |config|
                config.build_settings['DEVELOPMENT_TEAM'] = dev_team
            end
        end
    end
end
