//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

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

final class BrandsDataSourceMock: NSObject, CollectionViewDataProviding, CollectionViewNibRegistering {

    weak var delegate: CollectionViewHaving & CollectionViewControlling?
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
    var subject: BrandsInteractor!

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        dataSource = BrandsDataSourceMock()
        dataUpdateListener = DataUpdateListener()
        subject = BrandsInteractor(dataSource: dataSource)
        subject.dataUpdateListener = dataUpdateListener
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

    func test_reloadData_reloadsCollectionView() {
        subject.use(collectionView)

        subject.reloadData()

        XCTAssertTrue(collectionView.reloadDidCall)
    }

    func test_reloadData_informsThatDataLoadDidFinish() {
        subject.use(collectionView)

        subject.reloadData()

        XCTAssertTrue(dataUpdateListener.didFinish)
    }

    func test_refresh_reloadsCollectionVie() {
        subject.use(collectionView)

        subject.refresh()

        XCTAssertTrue(collectionView.reloadDidCall)

    }
}
