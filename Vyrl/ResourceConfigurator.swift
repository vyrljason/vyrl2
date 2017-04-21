//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

protocol APIResourceConfiguring {
    var resourceController: APIResourceControlling { get }
    var configuration: APIConfigurationHaving { get }
}

final class ResourceConfigurator: APIResourceConfiguring {

    private let responseHandler: APIResponseHandling
    let resourceController: APIResourceControlling
    let configuration: APIConfigurationHaving

    init(configuration: APIConfigurationHaving,
         sessionManager: SessionManaging,
         responseHandler: APIResponseHandling,
         requestDataProvider: RequestDataProviding) {
        self.configuration = configuration
        self.responseHandler = responseHandler
        self.resourceController = HTTPClient(manager: sessionManager, apiConfiguration: configuration, requestDataProvider: requestDataProvider, responseHandler: responseHandler)
    }
}
