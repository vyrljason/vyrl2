//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandsServiceMock: BrandsHaving {

    let brands: [Brand] = (0..<5).map { _ in VyrlFaker.faker.brand() }
    let error: BrandsError = .unknown
    var success = true

    func brands(completion: @escaping BrandsResultClosure) {
        if success {
            completion(.success(brands))
        } else {
            completion(.failure(error))
        }
    }
}

final class CollectionInteractorMock: CollectionViewHaving, CollectionViewControlling {
    var collectionView: UICollectionView?
    var didReloadData = false
    var didLoadData = false

    func reloadData() {
        didReloadData = true
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

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        service = BrandsServiceMock()
        interactor = CollectionInteractorMock()
        interactor.collectionView = collectionView
        subject = BrandsDataSource(repository: service)
        subject.delegate = interactor
    }

    func test_loadData_whenServiceReturnsDataSuccess_NumberOfItemsInCollectionViewIsCorrect() {
        service.success = true

        subject.loadData()

        XCTAssertEqual(subject.collectionView(interactor.collectionView!, numberOfItemsInSection: 1), service.brands.count)
    }

    func test_loadData_whenServiceReturnsDataSuccess_InformsDelegate() {
        service.success = true

        subject.loadData()

        XCTAssertTrue(interactor.didReloadData)
    }

    func test_loadData_whenServiceReturnsError_InformsDelegate() {
        service.success = false

        subject.loadData()

        XCTAssertTrue(interactor.didReloadData)
    }

    func test_loadData_whenServiceReturnsError_NumberOfItemsInCollectionViewIsZero() {
        service.success = false

        subject.loadData()

        XCTAssertEqual(subject.collectionView(interactor.collectionView!, numberOfItemsInSection: 1), 0)
    }
}
