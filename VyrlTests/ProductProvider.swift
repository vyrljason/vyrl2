//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ProductProvidingEror: Error {
    case unknown
}

protocol ProductProviding {
    func get(productId: String, completion: @escaping (Result<Product, ProductProvidingEror>) -> Void)
}

final class ProductProviderMock: ProductProviding {

    let mockedProduct: Product = Product(id: "",
                                         name: "Leica",
                                         retailPrice: 1_805_000,
                                         imageUrls: [])

    func get(productId: String, completion: @escaping (Result<Product, ProductProvidingEror>) -> Void) {
        completion(.success(mockedProduct))
    }
}
