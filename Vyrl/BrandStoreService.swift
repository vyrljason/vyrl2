//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ProductsProviding {
    func getProducts(for brand: Brand, completion: @escaping (Result<[Product], ServiceError>) -> Void)
}

final class BrandStoreService: ProductsProviding {
    
    private let resource: ParameterizedService<ProductsResource>
    
    init(resource: ParameterizedService<ProductsResource>) {
        self.resource = resource
    }

    func getProducts(for brand: Brand, completion: @escaping (Result<[Product], ServiceError>) -> Void) {
        resource.get(using: ProductsRequest(brand: brand)) { result in
            completion(result.map(success: { .success($0.products) }, failure: { .failure($0) }))
        }
    }
}
