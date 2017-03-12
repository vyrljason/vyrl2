//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class ProductsServiceMock: ProductsWithIdsProviding {

    var mockedProducts: [Product]? = [VyrlFaker.faker.product()]

    func getProducts(with productsIds: [String], completion: @escaping (Result<[Product], ServiceError>) -> Void) {
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
    var service: ProductsServiceMock!
    var tableView: TableViewMock!
    var emptyTableMock: EmptyTableViewHandlerMock!
    var summaryUpdateHandler: SummaryUpdateHandlingMock!

    override func setUp() {
        super.setUp()
        cartStorage = CartStoringMock()
        service = ProductsServiceMock()
        tableView = TableViewMock()
        emptyTableMock = EmptyTableViewHandlerMock()
        summaryUpdateHandler = SummaryUpdateHandlingMock()

        subject = CartDataSource(cartStorage: cartStorage, service: service)
        subject.emptyTableDelegate = emptyTableMock
        subject.summaryDelegate = summaryUpdateHandler
    }

    func test_loadData_noData_noDataMode() {
        cartStorage.items = []

        subject.loadData()

        XCTAssertEqual(emptyTableMock.currentMode, .noData)
    }

    func test_registerNibs_didRegisterNib() {
        subject.use(tableView)

        XCTAssertTrue(tableView.didRegisterNib)
    }

    func test_loadData_dataPresent_notifedSummaryDelegate() {
        let item = VyrlFaker.faker.cartItem()
        cartStorage.items = [item]

        subject.loadData()

        XCTAssertEqual(summaryUpdateHandler.summary?.productsCount, 1)
        XCTAssertEqual(summaryUpdateHandler.summary?.brandsCount, 1)
    }

    func test_loadData_numberOfItemsInSection_One() {
        cartStorage.items = [VyrlFaker.faker.cartItem()]

        subject.loadData()

        XCTAssertEqual(subject.tableView(tableView, numberOfRowsInSection: 0), 1)
    }

    func test_remove_removed() {
        let item = VyrlFaker.faker.cartItem()
        cartStorage.items = [item]
        service.mockedProducts = [VyrlFaker.faker.product(id: item.productId)]

        subject.loadData()

        subject.tableView(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cartStorage.items.isEmpty)
    }
}
