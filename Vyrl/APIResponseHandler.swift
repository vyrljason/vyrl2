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
            let statusCode: StatusCode? = StatusCode(httpStatusCode: response.response?.statusCode)
            switch response.jsonResult {
            case .success(let json):
                do {
                    let deserializedModel = try self.jsonDeserializer.deserialize(json: json, model: Model.self)
                    completion(.success(deserializedModel))
                } catch {
                    completion(.failure(APIResponseError(statusCode: statusCode,
                                                         error: error,
                                                         data: response.data)))
                }
            case .failure(let error):
                completion(.failure(APIResponseError(statusCode: statusCode,
                                                     error: error,
                                                     data: response.data)))
            }
        }
    }
}
