//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

enum ProductProvidingEror: Error {
    case unknown
}

protocol ProductProviding {
    func get(productId: String, completion: @escaping (Result<Product, ProductProvidingEror>) -> Void)
}

final class ProductProviderMock: ProductProviding {
    func get(productId: String, completion: @escaping (Result<Product, ProductProvidingEror>) -> Void) {
        completion(.success(VyrlFaker.faker.product()))
    }
}
