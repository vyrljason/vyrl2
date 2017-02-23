//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Alamofire
import Decodable

protocol APIResourceControlling {
    func call<Model: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<Model, APIResponseError>) -> Void)
}

final class HTTPClient: APIResourceControlling {

    private let manager: SessionManager
    private let apiConfiguration: APIConfiguration
    private let credentialsProvider: APICredentialsProviding
    private let responseHandler: APIResponseHandling

    init(manager: Alamofire.SessionManager,
         apiConfiguration: APIConfiguration,
         credentialsProvider: APICredentialsProviding,
         responseHandler: APIResponseHandling) {
        self.manager = manager
        self.apiConfiguration = apiConfiguration
        self.credentialsProvider = credentialsProvider
        self.responseHandler = responseHandler
    }

    func call<Model: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<Model, APIResponseError>) -> Void) {
        let url = apiConfiguration.baseURL.appendingPathComponent(endpoint.path)
        manager.request(url,
                        method: endpoint.method.alamofireMethod,
                        parameters: endpoint.parameters,
                        encoding: endpoint.encoding,
                        headers: headersFor(authorizationType: endpoint.authorization)).responseJSON { response in
                            self.responseHandler.handle(response: response, completion: completion)
        }
    }

    private func headersFor(authorizationType: AuthorizationType) -> [String: String] {
        return authorizationType.requestHeader(with: credentialsProvider.userAccessToken)
    }
}
