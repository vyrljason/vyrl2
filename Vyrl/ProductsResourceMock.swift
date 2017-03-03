//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class ProductsResourceMock: FetchingWithParameters {
    
    typealias Model = Products
    typealias Parameters = ProductsRequest
    private let products: Products
    var success = true
    
    init(amount: Int) {
        self.products = Products(products: (0..<amount).map { _ in VyrlFaker.faker.product() })
    }

    func fetchFiltered(using parameters: ProductsRequest?, completion: @escaping (Result<Products, APIResponseError>) -> Void) {
        if success {
            completion(.success(self.products))
        } else {
            let error = NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil)
            completion(.failure(.unexpectedFailure(error)))
        }
    }
}
