//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

protocol APIResourceConfiguring {
    var resourceController: APIResourceControlling { get }
}

final class ResourceConfigurator: APIResourceConfiguring {

    private let configuration: APIConfigurationHaving
    private let responseHandler: APIResponseHandling
    let resourceController: APIResourceControlling

    init(configuration: APIConfigurationHaving,
         sessionManager: SessionManaging,
         responseHandler: APIResponseHandling,
         headersProvider: HTTPHeadersProviding) {
        self.configuration = configuration
        self.responseHandler = responseHandler
        self.resourceController = HTTPClient(manager: sessionManager, apiConfiguration: configuration, headersProvider: headersProvider, responseHandler: responseHandler)
    }
}
