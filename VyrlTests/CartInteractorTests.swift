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

final class CartInteractorTests: XCTestCase {

    var subject: CartInteractor!
    var emptyTableHandler: EmptyTableViewHandlerMock!
    var dataSourceMock: CartDataProvidingMock!
    var tableView: TableViewMock!

    override func setUp() {
        super.setUp()

        emptyTableHandler = EmptyTableViewHandlerMock()
        dataSourceMock = CartDataProvidingMock()
        tableView = TableViewMock()

        subject = CartInteractor(dataSource: dataSourceMock, emptyTableHandler: emptyTableHandler)
    }

    func test_init_didSetDelegate() {
        subject.viewDidAppear()

        XCTAssertTrue(dataSourceMock.emptyTableDelegate === emptyTableHandler)
    }

    func test_viewDidLoad_madeDataSourceLoadData() {
        subject.viewDidAppear()

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
}
