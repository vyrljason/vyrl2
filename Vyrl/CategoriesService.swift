//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol CategoriesProviding {
    func get(completion: @escaping (Result<[Category], ServiceError>) -> Void)
}

final class CategoriesService: CategoriesProviding {

    private let resource: Service<CategoriesResourceMock>

    init(resource: Service<CategoriesResourceMock>) {
        self.resource = resource
    }

    func get(completion: @escaping (Result<[Category], ServiceError>) -> Void) {
        resource.get(completion: completion)
    }
}
