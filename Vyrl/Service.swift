//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol Fetching {
    associatedtype Model
    func fetch(completion: @escaping (Result<Model, APIResponseError>) -> Void)
}

final class Service<Resource: Fetching> {

    private let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }

    func get(completion: @escaping (Result<Resource.Model, ServiceError>) -> Void) {
        resource.fetch { result in
            switch result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(.apiResponseError(error)))
            }
        }
    }
}
