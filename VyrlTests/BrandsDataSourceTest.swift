//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandSelectionMock: BrandSelecting {
    var didSelectCalled = false

    func didSelect(brand: Brand) {
        didSelectCalled = true
    }
}
final class BrandsServiceMock: BrandsHaving {

    var brands: [Brand] = (0..<5).map { _ in VyrlFaker.faker.brand() }
    let error: BrandsError = .unknown
    var success = true
    var isResponseEmpty: Bool = false

    func brands(completion: @escaping BrandsResultClosure) {
        if success {
            completion(.success(isResponseEmpty ? [] : brands))
        } else {
            completion(.failure(error))
        }
    }
}

final class CollectionInteractorMock: CollectionViewHaving, CollectionViewControlling {
    var collectionView: UICollectionView?
    var updateResult: DataFetchResult?
    var didLoadData = false

    func updateCollection(with result: DataFetchResult) {
        updateResult = result
    }

    func loadData() {
        didLoadData = true
    }
}

final class BrandsDataSourceTest: XCTestCase {

    var collectionView: CollectionViewMock!
    var service: BrandsServiceMock!
    var interactor: CollectionInteractorMock!
    var subject: BrandsDataSource!
    var brandSelection: BrandSelectionMock!

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        service = BrandsServiceMock()
        brandSelection = BrandSelectionMock()
        interactor = CollectionInteractorMock()
        interactor.collectionView = collectionView

        subject = BrandsDataSource(repository: service)
        subject.delegate = interactor
        subject.selectionDelegate = brandSelection
    }

    func test_loadData_whenServiceReturnsDataSuccess_NumberOfItemsInCollectionViewIsCorrect() {
        service.success = true

        subject.loadData()

        XCTAssertEqual(subject.collectionView(interactor.collectionView!, numberOfItemsInSection: 1), service.brands.count)
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

        XCTAssertTrue(brandSelection.didSelectCalled)
    }
}
