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
    
    func appVersion() -> String {
        let version: String? = Bundle.main.object(forInfoDictionaryKey: Constants.bundleShortVersion) as? String
        return version ?? ""
    }
    
    func buildVersion() -> String {
        let bundle: String? = Bundle.main.object(forInfoDictionaryKey: Constants.bundleVersion) as? String
        return bundle ?? ""
    }
}
