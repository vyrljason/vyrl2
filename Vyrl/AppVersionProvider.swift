//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static let bundleShortVersion: String = "CFBundleShortVersionString"
    static let bundleVersion: String = "CFBundleVersion"
}

protocol AppVersionProviding {
    func appVersion() -> String
    func buildVersion() -> String
}

final class AppVersionService: AppVersionProviding {
    
    let bundle: Bundle
    
    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }
    
    func appVersion() -> String {
        let version: String? = bundle.object(forInfoDictionaryKey: Constants.bundleShortVersion) as? String
        return version ?? ""
    }
    
    func buildVersion() -> String {
        let build: String? = bundle.object(forInfoDictionaryKey: Constants.bundleVersion) as? String
        return build ?? ""
    }
}
