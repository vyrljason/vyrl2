//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol PostingWithParameters {
    associatedtype ResponseModel
    associatedtype Parameters: DictionaryConvertible
    func post(using parameters: Parameters, completion: @escaping (Result<ResponseModel, APIResponseError>) -> Void)
}

final class PostService<Resource: PostingWithParameters> {

    private let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }

    func post(using parameters: Resource.Parameters, completion: @escaping (Result<Resource.ResponseModel, ServiceError>) -> Void) {
        resource.post(using: parameters) { result in
            switch result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(.apiResponseError(error)))
            }
        }
    }
}
