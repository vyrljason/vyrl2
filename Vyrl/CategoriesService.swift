//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol CategoriesProviding {
    func get(completion: @escaping (Result<[Category], ServiceError>) -> Void)
}

final class CategoriesService: CategoriesProviding {

    private let resource: Service<CategoriesResource>

    init(resource: Service<CategoriesResource>) {
        self.resource = resource
    }

    func get(completion: @escaping (Result<[Category], ServiceError>) -> Void) {
        resource.get { (result) in
            completion(result.map(success: { .success($0.categories) }, failure: { .failure($0) }))
        }
    }
}
