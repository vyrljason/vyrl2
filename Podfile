platform :ios, '9.3'

target 'Vyrl' do
    use_frameworks!
    inhibit_all_warnings!

    pod 'Decodable'
    pod 'SwiftLint'
    pod 'Alamofire'
    pod 'KeychainAccess'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Whisper', :git => 'https://github.com/AllinMobile/Whisper'
    pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
    pod 'ReachabilitySwift', '~> 3'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'SlideMenuControllerSwift'
    pod 'Kingfisher'
    pod 'Fakery'
    pod 'DZNEmptyDataSet'
    pod 'JWTDecode'
    pod 'MBProgressHUD', '~> 1.0.0'

    target 'VyrlTests' do
        inherit! :search_paths
        pod 'Firebase'
        pod 'FBSnapshotTestCase'
        pod 'Fakery'
    end
end
