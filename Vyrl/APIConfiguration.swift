//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ConfigurationMode: String, CustomStringConvertible {
    case Staging
    case Production

    var description: String {
        return self.rawValue
    }
}

enum ConfigurationError: Error {
    case noConfigurationFile
    case noBaseURL
    case noAlternativeBaseURL
}

protocol APIConfigurationHaving {
    var mainBaseURL: URL { get }
    var influencersBaseURL: URL { get }
    var mode: ConfigurationMode { get }
}

final class APIConfiguration: APIConfigurationHaving {

    private struct ConfigurationKeys {
        static let configurationFile = "Configuration"
        static let mainBaseURL = "MainBaseURL"
        static let influencersBaseURL = "InfluencersBaseURL"
        static let defaultFileType = "plist"
    }

    private let configuration: [String: String]

    let mode: ConfigurationMode
    let mainBaseURL: URL
    let influencersBaseURL: URL

    init(bundle: Bundle = Bundle.main,
         plistName: String = ConfigurationKeys.configurationFile,
         mode: ConfigurationMode = .Staging) throws {
        guard let resourcePath = bundle.path(forResource: plistName,
                                             ofType: ConfigurationKeys.defaultFileType),
            let baseConfiguration = NSDictionary(contentsOfFile: resourcePath) as? [String: Any],
            let configuration = baseConfiguration[String(describing: mode)] as? [String: String] else { throw ConfigurationError.noConfigurationFile }

        self.configuration = configuration
        self.mode = mode
        guard let mainBaseURLString = configuration[ConfigurationKeys.mainBaseURL], let mainBaseURL = URL(string: mainBaseURLString) else {
            throw ConfigurationError.noBaseURL
        }
        self.mainBaseURL = mainBaseURL
        guard let influencersBaseURLString = configuration[ConfigurationKeys.influencersBaseURL], let influencersBaseURL = URL(string: influencersBaseURLString) else {
            throw ConfigurationError.noAlternativeBaseURL
        }
        self.influencersBaseURL = influencersBaseURL
    }
}
