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

    var mockedProducts: [Product]? = [VyrlFaker.faker.product()]

    func get(productsIds: [String], completion: @escaping (Result<[Product], ProductProvidingEror>) -> Void) {
        switch mockedProducts {
        case .some(let products):
            completion(.success(products))
        case .none:
            completion(.failure(.unknown))
        }
    }
}

final class SummaryUpdateHandlingMock: SummaryUpdateHandling {

    var summary: CartSummary?

    func didUpdate(summary: CartSummary) {
        self.summary = summary
    }
}

final class CartDataSourceTests: XCTestCase {

    var subject: CartDataSource!
    var cartStorage: CartStoringMock!
    var productProvider: ProductProvidingMock!
    var collectionView: CollectionViewMock!
    var emptyCollectionViewHandlerMock: EmptyCollectionViewHandlerMock!
    var summaryDelegate: SummaryUpdateHandlingMock!

    override func setUp() {
        super.setUp()
        cartStorage = CartStoringMock()
        productProvider = ProductProvidingMock()
        collectionView = CollectionViewMock()
        emptyCollectionViewHandlerMock = EmptyCollectionViewHandlerMock()
        summaryDelegate = SummaryUpdateHandlingMock()

        subject = CartDataSource(cartStorage: cartStorage, productProvider: productProvider)
        subject.emptyCollectionDelegate = emptyCollectionViewHandlerMock
        subject.summaryDelegate = summaryDelegate
    }

    func test_loadData_noData_noDataMode() {
        cartStorage.items = []

        subject.loadData()

        XCTAssertEqual(emptyCollectionViewHandlerMock.currentMode, .noData)
    }

    func test_registerNibs_didRegisterNib() {
        subject.registerNibs(in: collectionView)

        XCTAssertTrue(collectionView.didRegisterNib)
    }

    func test_loadData_dataPresent_notifedSummaryDelegate() {
        let item = VyrlFaker.faker.cartItem()
        cartStorage.items = [item]

        subject.loadData()

        XCTAssertEqual(summaryDelegate.summary?.productsCount, 1)
        XCTAssertEqual(summaryDelegate.summary?.brandsCount, 1)
    }

    func test_loadData_numberOfItemsInSection_One() {
        cartStorage.items = [VyrlFaker.faker.cartItem()]

        subject.loadData()

        XCTAssertEqual(subject.collectionView(collectionView, numberOfItemsInSection: 0), 1)
    }
}
