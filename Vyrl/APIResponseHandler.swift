//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

protocol APIResponseHandling {
    func handle<Model: Decodable>(response: DataResponseProtocol, completion: @escaping (Result<Model, APIResponseError>) -> Void)
}

final class APIResponseHandler: APIResponseHandling {

    var jsonDeserializer: JSONToModelDeserializing

    init(jsonDeserializer: JSONToModelDeserializing) {
        self.jsonDeserializer = jsonDeserializer
    }

    func handle<Model: Decodable>(response: DataResponseProtocol, completion: @escaping (Result<Model, APIResponseError>) -> Void) {
        guard let httpResponse = response.response else {
            fatalError("Unexpected error while finishing network request - no proper HTTP response nor expected error object")
        }
        let statusCode = StatusCode(rawValue: httpResponse.statusCode)
        if case .ok = statusCode {
            DispatchQueue.main.async {
                switch response.result {
                case .success(let json):
                    do {
                        let deserializedModel = try self.jsonDeserializer.deserialize(json: json, model: Model.self)
                        completion(.success(deserializedModel))
                    } catch {
                        completion(.failure(.modelDeserializationFailure(error)))
                    }
                case .failure(let error):
                    completion(.failure(APIResponseError(statusCode: statusCode, data: response.data, error: error)))
                }
            }
        } else {
            completion(.failure(APIResponseError(statusCode: statusCode, data: response.data)))
        }
    }
}
