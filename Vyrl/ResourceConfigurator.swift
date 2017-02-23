//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

protocol APIResourceConfiguring {
    var httpClient: APIResourceControlling { get }
}

final class ResourceConfigurator: APIResourceConfiguring {

    private let configuration: APIConfiguration
    private let responseHandler: APIResponseHandling
    let httpClient: APIResourceControlling

    init(configuration: APIConfiguration,
         sessionManager: SessionManager,
         responseHandler: APIResponseHandling,
         credentialsProvider: APICredentialsProviding) {
        self.configuration = configuration
        self.responseHandler = responseHandler
        self.httpClient = HTTPClient(manager: sessionManager, apiConfiguration: configuration, credentialsProvider: credentialsProvider, responseHandler: responseHandler)
    }
}
