//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ConfigurationMode: String, CustomStringConvertible {
    case staging
    case production

    var description: String {
        return self.rawValue
    }
}

enum ConfigurationError: Error {
    case noConfigurationFile
    case noBaseURL
}

protocol APIConfigurationHaving {
    var baseURL: URL { get }
    var mode: ConfigurationMode { get }
}

final class APIConfiguration: APIConfigurationHaving {

    private struct ConfigurationKeys {
        static let configurationFile    = "Configuration"
        static let baseURL              = "BaseURL"
        static let defaultFileType      = "plist"
    }

    private let configuration: [String: String]

    let mode: ConfigurationMode
    let baseURL: URL

    init(bundle: Bundle = Bundle.main,
         plistName: String = ConfigurationKeys.configurationFile,
         mode: ConfigurationMode = .staging) throws {
        guard let resourcePath = bundle.path(forResource: plistName,
                                             ofType: ConfigurationKeys.defaultFileType),
            let baseConfiguration = NSDictionary(contentsOfFile: resourcePath) as? [String: Any],
            let configuration = baseConfiguration[String(describing: mode)] as? [String: String] else { throw ConfigurationError.noConfigurationFile }

        self.configuration = configuration
        self.mode = mode
        guard let baseURLString = configuration[ConfigurationKeys.baseURL], let baseURL = URL(string: baseURLString) else {
            throw ConfigurationError.noBaseURL
        }
        self.baseURL = baseURL
    }
}
