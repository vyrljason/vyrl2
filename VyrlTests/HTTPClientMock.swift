//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Decodable
@testable import Vyrl

final class APIResourceControllerMock<Value: Decodable>: APIResourceControlling {

    var result: Value?
    var error: APIResponseError = .connectionProblem
    var success = true

    func call<Model: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<Model, APIResponseError>) -> Void) {
        if let result = result as? Model, success == true {
            completion(.success(result))
        } else {
            completion(.failure(error))
        }
    }

    func upload<Model: Decodable>(data: Data, toEndpoint endpoint: APIEndpoint, completion: @escaping (Result<Model, APIResponseError>) -> Void) {
        if let result = result as? Model, success == true {
            completion(.success(result))
        } else {
            completion(.failure(error))
        }
    }
}
