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
        let resourceConfigurator = ResourceConfigurator(configuration: apiConfiguration,
                                                        sessionManager: manager, responseHandler: responseHandler, credentialsProvider: credentialsProvider)
        return resourceConfigurator
    }
}
