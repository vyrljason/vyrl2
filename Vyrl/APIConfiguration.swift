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
    case noBaseLink
    case noAlternativeBaseLink
    case noFAQLink
    case noToSLink
}

protocol APIConfigurationHaving {
    var mainBaseURL: URL { get }
    var influencersBaseURL: URL { get }
    var mode: ConfigurationMode { get }
    var faqURL: URL { get }
    var tosURL: URL { get }
}

final class APIConfiguration: APIConfigurationHaving {

    private struct ConfigurationKeys {
        static let configurationFile = "Configuration"
        static let mainBaseURL = "MainBaseURL"
        static let influencersBaseURL = "InfluencersBaseURL"
        static let defaultFileType = "plist"
        static let faqURL = "FAQ"
        static let tosURL = "ToS"
    }

    private let configuration: [String: String]

    let mode: ConfigurationMode
    let mainBaseURL: URL
    let influencersBaseURL: URL
    let faqURL: URL
    let tosURL: URL

    init(bundle: Bundle = Bundle.main,
         plistName: String = ConfigurationKeys.configurationFile,
         mode: ConfigurationMode) throws {
        guard let resourcePath = bundle.path(forResource: plistName,
                                             ofType: ConfigurationKeys.defaultFileType),
            let baseConfiguration = NSDictionary(contentsOfFile: resourcePath) as? [String: Any],
            let configuration = baseConfiguration[String(describing: mode)] as? [String: String] else { throw ConfigurationError.noConfigurationFile }

        self.configuration = configuration
        self.mode = mode
        guard let mainBaseURLString = configuration[ConfigurationKeys.mainBaseURL], let mainBaseURL = URL(string: mainBaseURLString) else {
            throw ConfigurationError.noBaseLink
        }
        self.mainBaseURL = mainBaseURL
        guard let influencersBaseURLString = configuration[ConfigurationKeys.influencersBaseURL], let influencersBaseURL = URL(string: influencersBaseURLString) else {
            throw ConfigurationError.noAlternativeBaseLink
        }
        self.influencersBaseURL = influencersBaseURL

        guard let faqURLString = configuration[ConfigurationKeys.faqURL], let faqURL = URL(string: faqURLString) else {
            throw ConfigurationError.noFAQLink
        }
        self.faqURL = faqURL

        guard let tosURLString = configuration[ConfigurationKeys.tosURL], let tosURL = URL(string: tosURLString) else {
            throw ConfigurationError.noToSLink
        }
        self.tosURL = tosURL
    }
}
