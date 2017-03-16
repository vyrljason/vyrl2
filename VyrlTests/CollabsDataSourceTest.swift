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

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        service = CollabsServiceMock()
        selectionHandler = CollabSelectionMock()
        interactor = CollectionInteractorMock()
        interactor.collectionView = collectionView

        subject = CollabsDataSource(service: service)
        subject.collectionViewControllingDelegate = interactor
        subject.selectionDelegate = selectionHandler
    }

    func test_loadData_whenServiceReturnsDataSuccess_NumberOfItemsInCollectionViewIsCorrect() {
        service.success = true

        subject.loadData()

        XCTAssertEqual(subject.collectionView(interactor.collectionView!, numberOfItemsInSection: 1), service.items.count)
    }

    func test_loadData_whenServiceReturnsNonEmptyDataSuccess_InformsDelegate() {
        service.success = true

        subject.loadData()

        XCTAssertEqual(interactor.updateResult, .someData)
    }

    func test_loadData_whenServiceReturnsEmptyDataSuccess_InformsDelegate() {
        service.success = true
        service.isResponseEmpty = true

        subject.loadData()

        XCTAssertEqual(interactor.updateResult, .empty)
    }

    func test_loadData_whenServiceReturnsError_InformsDelegate() {
        service.success = false

        subject.loadData()

        XCTAssertEqual(interactor.updateResult, .error)
    }

    func test_loadData_whenServiceReturnsError_NumberOfItemsInCollectionViewIsZero() {
        service.success = false

        subject.loadData()

        XCTAssertEqual(subject.collectionView(interactor.collectionView!, numberOfItemsInSection: 1), 0)
    }

    func test_didSelect_callsSelectionDelegate() {
        subject.loadData()
        let indexPath = IndexPath(item: 0, section: 0)
        
        subject.collectionView(interactor.collectionView!, didSelectItemAt: indexPath)
        
        XCTAssertTrue(selectionHandler.didSelectCalled)
    }
}
