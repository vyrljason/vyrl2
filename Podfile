platform :ios, '9.3'

target 'Vyrl' do
    use_frameworks!

    pod 'Decodable'
    pod 'Alamofire'
    pod 'KeychainAccess'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Whisper', :git => 'https://github.com/AllinMobile/Whisper'
    pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
    pod 'ReachabilitySwift', '~> 3'
    pod 'Firebase', '~> 3.0'
    pod 'SlideMenuControllerSwift'

    target 'VyrlTests' do
        inherit! :search_paths
        pod 'FBSnapshotTestCase'
        pod 'Fakery'
    end
end

