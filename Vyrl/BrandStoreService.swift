//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ProductsProviding {
    func get(completion: @escaping (Result<[Product], ServiceError>) -> Void)
}

final class BrandStoreService: ProductsProviding {
    
    private let resource: Service<ProductsResourceMock>
    
    init(resource: Service<ProductsResourceMock>) {
        self.resource = resource
    }
    
    func get(completion: @escaping (Result<[Product], ServiceError>) -> Void) {
        resource.get(completion: completion)
    }
}
