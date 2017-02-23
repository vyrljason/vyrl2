//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum BrandsError: Error {
    case unknown
}

protocol BrandsProviding {
    func get(completion: @escaping (Result<[Brand], ServiceError>) -> Void)
}

final class BrandsService: BrandsProviding {

    private let resource: Service<BrandsResourceMock>

    init(resource: Service<BrandsResourceMock>) {
        self.resource = resource
    }

    func get(completion: @escaping (Result<[Brand], ServiceError>) -> Void) {
        resource.get(completion: completion)
    }
}
