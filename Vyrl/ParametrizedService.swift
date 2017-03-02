//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol FetchingWithParameters {
    associatedtype Model
    associatedtype Parameters: DictionaryConvertible
    func fetchFiltered(using parameters: Parameters?, completion: @escaping (Result<Model, APIResponseError>) -> Void)
}

final class ParameterizedService<Resource: FetchingWithParameters> {

    private let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }

    func get(using parameters: Resource.Parameters?, completion: @escaping (Result<Resource.Model, ServiceError>) -> Void) {
        resource.fetchFiltered(using: parameters) { result in
            switch result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(.apiResponseError(error)))
            }
        }
    }
}
