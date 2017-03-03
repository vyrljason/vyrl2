//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

protocol ProductsWithIdsProviding {
    func getProducts(with productsIds: [String], completion: @escaping (Result<[Product], ServiceError>) -> Void)
}

final class ProductsService: ProductsWithIdsProviding {

    private let resource: ParameterizedService<ProductsResource>

    init(resource: ParameterizedService<ProductsResource>) {
        self.resource = resource
    }

    func getProducts(with productsIds: [String], completion: @escaping (Result<[Product], ServiceError>) -> Void) {
        resource.get(using: ProductsRequest(productIds: productsIds)) { result in
            completion(result.map(success: { .success($0.products) }, failure: { .failure($0) }))
        }
    }
}
