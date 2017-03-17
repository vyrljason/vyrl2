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

final class BrandsDataSourceMock: NSObject, BrandsDataProviding, BrandsFilteredByCategoryProviding {

    weak var collectionViewControllingDelegate: CollectionViewHaving & CollectionViewControlling?
    weak var selectionDelegate: BrandSelecting?
    var didLoad = false
    var category: Vyrl.Category?
    var didRegisterNibs = false

    func loadData() {
        didLoad = true
    }

    func loadData(filteredBy category: Vyrl.Category?) {
        self.category = category
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

final class BrandsInteractorTest: XCTestCase {

    var collectionView: CollectionViewMock!
    var dataSource: BrandsDataSourceMock!
    var dataUpdateListener: DataUpdateListenerMock!
    var emptyCollectionHandler: EmptyCollectionViewHandlerMock!
    var storePresenter: BrandStorePresenterMock!
    var subject: BrandsInteractor!

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        dataSource = BrandsDataSourceMock()
        dataUpdateListener = DataUpdateListenerMock()
        emptyCollectionHandler = EmptyCollectionViewHandlerMock()
        storePresenter = BrandStorePresenterMock()
        subject = BrandsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
        subject.dataUpdateListener = dataUpdateListener
        subject.brandStorePresenter = storePresenter
        dataSource.collectionViewControllingDelegate = subject
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

    func test_loadDataWithFilter_calledfilteredBy() {
        let category = Vyrl.Category(id: "0", name: "")
        subject.filterBrands(by: category)

        XCTAssertTrue(dataSource.didLoad)
        XCTAssertEqual(dataSource.category?.id, category.id)
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

    func test_refresh_reloadsDataFromDataSource() {
        subject.use(collectionView)

        subject.refreshData()

        XCTAssertTrue(dataSource.didLoad)
    }

    func test_didSelect_callsStorePresenter() {
        let brand = VyrlFaker.faker.brand()

        subject.didSelect(brand: brand)

        XCTAssertTrue(storePresenter.didCallPresentStore)
    }
}
