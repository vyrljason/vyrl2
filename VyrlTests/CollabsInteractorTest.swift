//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CollabsDataSourceMock: CollectionDataSourceMock, CollabsDataProviding {
    weak var selectionDelegate: CollabSelecting?
    weak var reloadingDelegate: ReloadingData?
    weak var emptyCollectionHandler: EmptyCollectionViewHandling?
    weak var collectionUpdateListener: CollectionUpateListening?
    var updateResult: DataFetchResult?

    func updateCollection(with result: DataFetchResult) {
        updateResult = result
    }
}

final class CollabsInteractorTest: XCTestCase {

    var subject: CollabsInteractor!
    var dataSource: CollabsDataSourceMock!
    var collectionView: CollectionViewMock!
    var dataUpdateListener: DataUpdateListenerMock!
    var emptyCollectionViewHandler: EmptyCollectionViewHandlerMock!

    override func setUp() {
        dataSource = CollabsDataSourceMock()
        collectionView = CollectionViewMock()
        dataUpdateListener = DataUpdateListenerMock()
        emptyCollectionViewHandler = EmptyCollectionViewHandlerMock()
        subject = CollabsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionViewHandler)
        subject.dataUpdateListener = dataUpdateListener
        dataSource.selectionDelegate = subject
    }

    func test_viewWillAppear_callsDataSourceLoadData() {
        subject.viewWillAppear()

        XCTAssertTrue(dataSource.didLoadData)
    }

    func test_loadData_informsThatDataLoadWillStart() {
        subject.loadData()

        XCTAssertTrue(dataUpdateListener.willStart)
    }

    func test_didUpdateCollection_informsThatDataLoadDidFinish() {
        subject.use(collectionView)

        subject.didUpdateCollection()

        XCTAssertTrue(dataUpdateListener.didFinish)
    }

    func test_loadData_callsDataSourceLoadData() {
        subject.loadData()

        XCTAssertTrue(dataSource.didLoadData)
    }

    func test_refresh_reloadsDataFromDataSource() {
        subject.use(collectionView)

        subject.refreshData()

        XCTAssertTrue(dataSource.didLoadData)
    }
}
