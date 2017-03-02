//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Alamofire

enum ResourceConfiguratorFactory {
    static func make(using apiConfiguration: APIConfigurationHaving) -> ResourceConfigurator {
        let manager = SessionManager()
        let jsonDeserializer = JSONToModelDeserializer()
        let responseHandler = APIResponseHandler(jsonDeserializer: jsonDeserializer)
        let credentialsStorage = CredentialsStorage()
        let credentialsProvider = APICredentialsProvider(storage: credentialsStorage)
        let requestDataProvider = RequestDataProvider(credentialsProvider: credentialsProvider)
        let resourceConfigurator = ResourceConfigurator(configuration: apiConfiguration,
                                                        sessionManager: manager, responseHandler: responseHandler, requestDataProvider: requestDataProvider)
        return resourceConfigurator
    }
}

enum SessionManagerFactory {
    static func make(apiConfiguration: APIConfigurationHaving) -> SessionManager {
        let manager: Alamofire.SessionManager = {
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                apiConfiguration.influencersBaseURL.absoluteString: .pinCertificates(
                    certificates: ServerTrustPolicy.certificates(),
                    validateCertificateChain: true,
                    validateHost: true
                ),
                "insecure.expired-apis.com": .disableEvaluation
            ]
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            let manager = Alamofire.SessionManager(
                configuration: configuration,
                serverTrustPolicyManager: VyrlServerTrustPolicyManager(policies: serverTrustPolicies)
            )
            return manager
        }()
        return manager
    }
}
