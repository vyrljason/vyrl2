//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class ProductsResource: FetchingWithParameters, APIResource {

    typealias Model = Products
    typealias Parameters = ProductsRequest
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func fetchFiltered(using parameters: ProductsRequest?, completion: @escaping (Result<Products, APIResponseError>) -> Void) {
        controller.call(endpoint: ProductsEndpoint(request: parameters), completion: completion)
    }
}
