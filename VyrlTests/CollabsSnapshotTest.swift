//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CollabsInteractorNoDataMock: CollabsInteracting, DataRefreshing {

    var collectionView: UICollectionView?
    fileprivate var emptyCollectionHandler: EmptyCollectionViewHandling = CollabsViewControllerFactory.emptyCollectionViewHandler()
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var messagesPresenter: MessagesPresenting?

    func viewWillAppear() { }

    func updateCollection(with result: DataFetchResult) { }

    func loadData() { }

    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        emptyCollectionHandler.use(collectionView)
        emptyCollectionHandler.configure(with: .noData)
        collectionView.reloadEmptyDataSet()
    }

    func refreshData() { }

    func didSelect(collab: Collab) { }

    func didUpdateCollection() { }
}

final class CollabsControllerSnapshotTest: SnapshotTestCase {

    private var subject: CollabsViewController!
    private var interactor: CollabsInteractorNoDataMock!

    override func setUp() {
        super.setUp()
        interactor = CollabsInteractorNoDataMock()
        subject = CollabsViewController(interactor: interactor)

        recordMode = false
    }
    
    func testCollabsWithNoData() {
        _ = subject.view

        interactor.updateCollection(with: .empty)

        verifyForScreens(view: subject.view)
    }
}
