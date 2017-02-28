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

    let mockedProduct: Product = Product(title: "Leica",
                                         subTitle: "Custom-made by Jony Ive and Marc Newson",
                                         price: "$1,805,000",
                                         url: nil)

    func get(productId: String, completion: @escaping (Result<Product, ProductProvidingEror>) -> Void) {
        completion(.success(mockedProduct))
    }
}
