//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class CartDataProvidingMock: NSObject, CartDataProviding {

    weak var emptyTableDelegate: EmptyTableViewHandling?
    weak var reloadingDelegate: ReloadingData?
    weak var summaryDelegate: SummaryUpdateHandling?
    weak var guidelinesDelegate: GuidelinesPresenting? 

    var didLoad = false
    var didCallUseTableView = false
    var cartData: CartData = CartData(products: [VyrlFaker.faker.product()], cartItems: [VyrlFaker.faker.cartItem()])

    func loadData() {
        didLoad = true
    }

    func use(_ tableView: UITableView) {
        didCallUseTableView = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

final class CartNavigatingMock: CartNavigating {
    weak var cartNavigationController: UINavigationController?
    weak var chatPresenter: ChatPresenting?
    var cart: CartViewController!
    var cartData: CartData?

    func pushCheckout(with cartData: CartData) {
        self.cartData = cartData
    }
}

final class CartInteractorTests: XCTestCase {

    var subject: CartInteractor!
    var emptyTableHandler: EmptyTableViewHandlerMock!
    var dataSourceMock: CartDataProvidingMock!
    var tableView: TableViewMock!
    var cartNavigation: CartNavigatingMock!

    override func setUp() {
        super.setUp()

        emptyTableHandler = EmptyTableViewHandlerMock()
        dataSourceMock = CartDataProvidingMock()
        tableView = TableViewMock()
        cartNavigation = CartNavigatingMock()

        subject = CartInteractor(dataSource: dataSourceMock, emptyTableHandler: emptyTableHandler)
        subject.cartNavigation = cartNavigation
    }

    func test_init_didSetDelegate() {
        subject.viewWillAppear()

        XCTAssertTrue(dataSourceMock.emptyTableDelegate === emptyTableHandler)
    }

    func test_viewDidLoad_madeDataSourceLoadData() {
        subject.viewWillAppear()

        XCTAssertTrue(dataSourceMock.didLoad)
    }

    func test_use_madeEmptyCollectionHandlerUseCollectionView() {
        subject.use(tableView)

        XCTAssertTrue(emptyTableHandler.useDidCall)
    }

    func test_use_didUse() {
        subject.use(tableView)

        XCTAssertTrue(dataSourceMock.didCallUseTableView)
    }

    func test_didTapRequest_didShowChexkout() {
        subject.viewWillAppear()

        subject.didTapRequest()

        XCTAssertNotNil(cartNavigation.cartData)
    }
}
