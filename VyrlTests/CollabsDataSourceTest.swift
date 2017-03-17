//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CollabSelectionMock: CollabSelecting {
    var didSelectCalled = false

    func didSelect(collab: Collab) {
        didSelectCalled = true
    }
}

final class CollabsServiceMock: CollabsProviding {

    var items: [Collab] = (0..<5).map { _ in VyrlFaker.faker.collab() }
    let error: ServiceError = .unknown
    var success = true
    var isResponseEmpty: Bool = false

    func getCollabs(completion: @escaping (Result<[Collab], ServiceError>) -> Void) {
        if success {
            completion(.success(isResponseEmpty ? [] : items))
        } else {
            completion(.failure(error))
        }
    }
}

final class CollabsDataSourceTest: XCTestCase {

    var collectionView: CollectionViewMock!
    var service: CollabsServiceMock!
    var interactor: CollectionInteractorMock!
    var subject: CollabsDataSource!
    var selectionHandler: CollabSelectionMock!
    var emptyCollectionViewHandler: EmptyCollectionViewHandlerMock!

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        service = CollabsServiceMock()
        emptyCollectionViewHandler = EmptyCollectionViewHandlerMock()

        selectionHandler = CollabSelectionMock()
        interactor = CollectionInteractorMock()
        interactor.collectionView = collectionView

        subject = CollabsDataSource(service: service)
        subject.selectionDelegate = selectionHandler
        subject.reloadingDelegate = collectionView
    }

    func test_loadData_whenServiceReturnsDataSuccess_NumberOfItemsInCollectionViewIsCorrect() {
        service.success = true

        subject.loadData()

        XCTAssertEqual(subject.collectionView(interactor.collectionView!, numberOfItemsInSection: 1), service.items.count)
    }

    func test_loadData_whenServiceReturnsError_NumberOfItemsInCollectionViewIsZero() {
        service.success = false

        subject.loadData()

        XCTAssertEqual(subject.collectionView(interactor.collectionView!, numberOfItemsInSection: 1), 0)
    }

    func test_updateCollection_reloadsCollectionView() {
        subject.use(collectionView)

        subject.updateCollection(with: .someData)

        XCTAssertTrue(collectionView.reloadDidCall)
    }

    func test_use_setsDataSourceAndDelegate() {
        subject.use(collectionView)

        XCTAssertTrue(collectionView.didSetDelegation)
        XCTAssertTrue(collectionView.dataSourceDidSet)
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

    func test_didSelect_callsSelectionDelegate() {
        subject.loadData()
        let indexPath = IndexPath(item: 0, section: 0)
        
        subject.collectionView(interactor.collectionView!, didSelectItemAt: indexPath)
        
        XCTAssertTrue(selectionHandler.didSelectCalled)
    }
}
