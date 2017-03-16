//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CollabsdDataSourceMock: CollectionDataSourceMock, CollabsDataProviding {
    weak var selectionDelegate: CollabSelecting?
}

final class CollabsInteractorTest: XCTestCase {

    var subject: CollabsInteractor!
    var dataSource: CollabsdDataSourceMock!
    var collectionView: CollectionViewMock!
    var dataUpdateListener: DataUpdateListenerMock!
    var emptyCollectionViewHandler: EmptyCollectionViewHandlerMock!

    override func setUp() {
        dataSource = CollabsdDataSourceMock()
        collectionView = CollectionViewMock()
        dataUpdateListener = DataUpdateListenerMock()
        emptyCollectionViewHandler = EmptyCollectionViewHandlerMock()
        subject = CollabsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionViewHandler)
        subject.dataUpdateListener = dataUpdateListener
        dataSource.collectionViewControllingDelegate = subject
        dataSource.selectionDelegate = subject
    }

    func test_use_registersNibs() {
        subject.use(collectionView)

        XCTAssertTrue(dataSource.didRegisterNibs)
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

    func test_use_setsDataSourceAndDelegate() {
        subject.use(collectionView)

        XCTAssertTrue(collectionView.didSetDelegation)
        XCTAssertTrue(collectionView.dataSourceDidSet)
    }

    func test_loadData_callsDataSourceLoadData() {
        subject.loadData()

        XCTAssertTrue(dataSource.didLoadData)
    }

    func test_updateCollection_reloadsCollectionViewInAllCases() {
        subject.use(collectionView)
        let possibleResults = [DataFetchResult.someData, DataFetchResult.empty, DataFetchResult.error]

        for result in possibleResults {
            collectionView.reloadDidCall = false
            subject.updateCollection(with: result)
            XCTAssertTrue(collectionView.reloadDidCall)
        }
    }

    func test_refresh_reloadsDataFromDataSource() {
        subject.use(collectionView)

        subject.refreshData()

        XCTAssertTrue(dataSource.didLoadData)
    }
}
