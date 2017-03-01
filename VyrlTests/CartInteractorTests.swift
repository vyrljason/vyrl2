//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class CartDataProvidingMock: NSObject, CartDataProviding {

    weak var emptyCollectionDelegate: EmptyCollectionViewHandling?
    weak var reloadingDelegate: ReloadingData?
    weak var summaryDelegate: SummaryUpdateHandling?

    var didLoad = false
    var didRegisterNibs = false

    func loadData() {
        didLoad = true
    }

    func registerNibs(in collectionView: UICollectionView) {
        didRegisterNibs = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

final class CartInteractorTests: XCTestCase {

    var subject: CartInteractor!
    var emptyCollectionHandler: EmptyCollectionViewHandlerMock!
    var dataSourceMock: CartDataProvidingMock!
    var collectionView: CollectionViewMock!

    override func setUp() {
        super.setUp()

        emptyCollectionHandler = EmptyCollectionViewHandlerMock()
        dataSourceMock = CartDataProvidingMock()
        collectionView = CollectionViewMock()

        subject = CartInteractor(dataSource: dataSourceMock, emptyCollectionHandler: emptyCollectionHandler)
    }

    func test_init_didSetDelegate() {
        subject.viewDidAppear()

        XCTAssertTrue(dataSourceMock.emptyCollectionDelegate === emptyCollectionHandler)
    }

    func test_viewDidLoad_madeDataSourceLoadData() {
        subject.viewDidAppear()

        XCTAssertTrue(dataSourceMock.didLoad)
    }

    func test_use_madeDataSourceUseCollectionView() {
        subject.use(collectionView)

        XCTAssertTrue(collectionView.delegate === dataSourceMock)
        XCTAssertTrue(collectionView.dataSource === dataSourceMock)
    }

    func test_use_madeEmptyCollectionHandlerUseCollectionView() {
        subject.use(collectionView)

        XCTAssertTrue(emptyCollectionHandler.useDidCall)
    }

    func test_use_didRegisterNibs() {
        subject.use(collectionView)

        XCTAssertTrue(dataSourceMock.didRegisterNibs)
    }
}
