//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Decodable
import Alamofire

protocol APIResourceControlling {
    func call<Model: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<Model, APIResponseError>) -> Void)
}

final class HTTPClient: APIResourceControlling {

    private let manager: SessionManaging
    private let apiConfiguration: APIConfigurationHaving
    private let responseHandler: APIResponseHandling
    private let requestDataProvider: RequestDataProviding

    init(manager: SessionManaging,
         apiConfiguration: APIConfigurationHaving,
         requestDataProvider: RequestDataProviding,
         responseHandler: APIResponseHandling) {
        self.manager = manager
        self.apiConfiguration = apiConfiguration
        self.requestDataProvider = requestDataProvider
        self.responseHandler = responseHandler
    }

    func call<Model: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<Model, APIResponseError>) -> Void) {
        let url = endpoint.api.baseURL(using: apiConfiguration).appendingPathComponent(endpoint.path)
        manager.request(url,
                        method: endpoint.method.alamofireMethod,
                        parameters: requestDataProvider.parameters(for: endpoint),
                        encoding: endpoint.encoding,
                        headers: requestDataProvider.headers(for: endpoint)).responseJSON { (response: DataResponse<Any>) in
                            self.responseHandler.handle(response: response, completion: completion)

        }
    }
}
