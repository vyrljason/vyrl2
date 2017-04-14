//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import Alamofire

protocol APIResponseHandling {
    func handle<Model: Decodable, ResponseType: DataResponseProtocol>(response: ResponseType, completion: @escaping (Result<Model, APIResponseError>) -> Void)
}

final class APIResponseHandler: APIResponseHandling {

    var jsonDeserializer: JSONToModelDeserializing

    init(jsonDeserializer: JSONToModelDeserializing) {
        self.jsonDeserializer = jsonDeserializer
    }

    func handle<Model: Decodable, ResponseType: DataResponseProtocol>(response: ResponseType, completion: @escaping (Result<Model, APIResponseError>) -> Void) {
        DispatchQueue.onMainThread {
            let statusCode: StatusCode = StatusCode(httpStatusCode: response.response?.statusCode)
            switch (response.jsonResult, statusCode) {
            case (.success(let json), .ok):
                do {
                    let deserializedModel = try self.jsonDeserializer.deserialize(json: json, model: Model.self)
                    completion(.success(deserializedModel))
                } catch {
                    completion(.failure(APIResponseError(statusCode: statusCode,
                                                         error: error,
                                                         data: response.data)))
                }
            case (.failure(let error), _):
                completion(.failure(APIResponseError(statusCode: statusCode,
                                                     error: error,
                                                     data: response.data)))
            default:
                let responseCode = response.response?.statusCode ?? 0
                let error = NSError(domain: "", code: responseCode, userInfo: nil)
                completion(.failure(APIResponseError(statusCode: statusCode, error: error)))
            }
        }
    }
}
