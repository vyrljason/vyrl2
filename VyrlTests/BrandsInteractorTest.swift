//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandStorePresenterMock: BrandStorePresenting {
    var didCallPresentStore = false

    func presentStore(for brand: Brand, animated: Bool) {
        didCallPresentStore = true
    }
}

final class DataUpdateListener: DataLoadingEventsListening {
    var willStart = false
    var didFinish = false

    func willStartDataLoading() {
        willStart = true
    }

    func didFinishDataLoading() {
        didFinish = true
    }
}

final class BrandsDataSourceMock: NSObject, BrandsDataProviding {

    weak var delegate: CollectionViewHaving & CollectionViewControlling?
    weak var selectionDelegate: BrandSelecting?
    var didLoad = false
    var didRegisterNibs = false

    func loadData() {
        didLoad = true
    }

    func registerNibs() {
        didRegisterNibs = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

final class BrandsInteractorTest: XCTestCase {

    var collectionView: CollectionViewMock!
    var dataSource: BrandsDataSourceMock!
    var dataUpdateListener: DataUpdateListener!
    var emptyCollectionHandler: EmptyCollectionViewHandlerMock!
    var storePresenter: BrandStorePresenterMock!
    var subject: BrandsInteractor!

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        dataSource = BrandsDataSourceMock()
        dataUpdateListener = DataUpdateListener()
        emptyCollectionHandler = EmptyCollectionViewHandlerMock()
        storePresenter = BrandStorePresenterMock()
        subject = BrandsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
        subject.dataUpdateListener = dataUpdateListener
        subject.brandStorePresenter = storePresenter
        dataSource.delegate = subject
    }

    func test_use_setsDelegateDataSourceAndRegisterNibs() {

        subject.use(collectionView)

        XCTAssertTrue(collectionView.didSetDelegation)
        XCTAssertTrue(collectionView.dataSourceDidSet)
        XCTAssertTrue(dataSource.didRegisterNibs)
    }

    func test_loadData_callsDataSource() {
        subject.loadData()

        XCTAssertTrue(dataSource.didLoad)
    }

    func test_loadData_informsThatDataLoadWillStart() {
        subject.loadData()

        XCTAssertTrue(dataUpdateListener.willStart)
    }

    func test_updateCollection_reloadsCollectionView() {
        subject.use(collectionView)

        subject.updateCollection(with: .someData)

        XCTAssertTrue(collectionView.reloadDidCall)
    }

    func test_reloadData_informsThatDataLoadDidFinish() {
        subject.use(collectionView)

        subject.updateCollection(with: .someData)

        XCTAssertTrue(dataUpdateListener.didFinish)
    }

    func test_updateCollection_whenResultIsEmpty_informsEmptyCollectionHandler() {
        subject.use(collectionView)

        subject.updateCollection(with: .empty)

        XCTAssertEqual(emptyCollectionHandler.currentMode, .noData)
    }

    func test_updateCollection_whenResultIsError_informsEmptyCollectionHandler() {
        subject.use(collectionView)

        subject.updateCollection(with: .error)

        XCTAssertEqual(emptyCollectionHandler.currentMode, .error)
    }

    func test_refresh_reloadsCollectionVie() {
        subject.use(collectionView)

        subject.refresh()

        XCTAssertTrue(collectionView.reloadDidCall)
    }

    func test_didSelect_callsStorePresenter() {
        let brand = VyrlFaker.faker.brand()

        subject.didSelect(brand: brand)

        XCTAssertTrue(storePresenter.didCallPresentStore)
    }
}
