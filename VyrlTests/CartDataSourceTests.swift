//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class CartStoringMock: CartStoring {
    var items: [CartItem] = []

    func add(item: CartItem) { }
    func remove(item: CartItem) { }
}

final class ProductProvidingMock: ProductProviding {

    var mockedProduct: Product? = Product(id: "",
                                          name: "Leica",
                                          retailPrice: 1_805_000,
                                          imageUrls: [])

    func get(productId: String, completion: @escaping (Result<Product, ProductProvidingEror>) -> Void) {
        switch mockedProduct {
        case .some(let product):
            completion(.success(product))
        case .none:
            completion(.failure(.unknown))
        }
    }
}

final class CartDataSourceTests: XCTestCase {

    var subject: CartDataSource!
    var cartStorage: CartStoringMock!
    var productProvider: ProductProvidingMock!
    var collectionView: CollectionViewMock!
    var emptyCollectionViewHandlerMock: EmptyCollectionViewHandlerMock!

    override func setUp() {
        super.setUp()
        cartStorage = CartStoringMock()
        productProvider = ProductProvidingMock()
        collectionView = CollectionViewMock()
        emptyCollectionViewHandlerMock = EmptyCollectionViewHandlerMock()

        subject = CartDataSource(cartStorage: cartStorage, productProvider: productProvider)
        subject.delegate = emptyCollectionViewHandlerMock
    }

    func test_loadData_noData_noDataMode() {
        subject.loadData()

        cartStorage.items = []

        XCTAssertEqual(emptyCollectionViewHandlerMock.currentMode, .noData)
    }

    func test_loadData_registerNibs_didRegisterNib() {
        subject.registerNibs(in: collectionView)

        XCTAssertTrue(collectionView.didRegisterNib)
    }

    func test_loadData_numberOfItemsInSection_One() {
        cartStorage.items = [CartItem(id: "", addedAt: Date())]

        XCTAssertEqual(subject.collectionView(collectionView, numberOfItemsInSection: 0), 1)
    }
}
