//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Alamofire
import Decodable

protocol APICredentialsProviding {
    var userAccessToken: String? { get }
}

final class HTTPClient {

    private let manager: SessionManager
    private let apiConfiguration: APIConfiguration
    private let credentialsProvider: APICredentialsProviding

    init(manager: Alamofire.SessionManager,
         apiConfiguration: APIConfiguration,
         credentialsProvider: APICredentialsProviding) {
        self.manager = manager
        self.apiConfiguration = apiConfiguration
        self.credentialsProvider = credentialsProvider
    }

    func call<Model: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<Model, APIResponseError>) -> Void) {
        let url = apiConfiguration.baseURL.appendingPathComponent(endpoint.path)
        manager.request(url,
                        method: endpoint.method.alamofireMethod,
                        parameters: endpoint.parameters,
                        encoding: endpoint.encoding,
                        headers: headersFor(authorizationType: endpoint.authorization)).responseJSON { response in
                            guard let httpResponse = response.response else {
                                fatalError("Unexpected error while finishing network request - no proper HTTP response nor expected error object")
                            }
                            let statusCode = StatusCode(rawValue: httpResponse.statusCode)
                            if case .ok = statusCode {
                                DispatchQueue.main.async {
                                    switch response.result {
                                    case .failure(let error):
                                        completion(.failure(APIResponseError(statusCode: statusCode, data: response.data, error: error)))
                                    case .success(let json):
                                        do {
                                            let deserializer = JSONToModelDeserializer()
                                            let deserializedModel = try deserializer.deserialize(json: json, model: Model.self)
                                            completion(.success(deserializedModel))
                                        } catch {
                                            completion(.failure(.modelDeserializationFailure(error)))
                                        }
                                    }
                                }
                            } else {
                                completion(.failure(APIResponseError(statusCode: statusCode, data: response.data)))
                            }
        }
    }

    private func headersFor(authorizationType: AuthorizationType) -> [String: String] {
        switch authorizationType {
        case .none: return [:]
        case .user:
            guard let accessToken = credentialsProvider.userAccessToken else { return [:] }
            return [authorizationType.headerKey: accessToken]
        }
    }
}
