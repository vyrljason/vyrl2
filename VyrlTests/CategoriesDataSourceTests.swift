//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class CategoryServiceMock: CategoriesProviding {

    var response: Result<[Vyrl.Category], ServiceError>?

    func get(completion: @escaping (Result<[Vyrl.Category], ServiceError>) -> Void) {
        if let response = self.response {
            completion(response)
        }
    }
}

final class CategoriesDataSourceTests: XCTestCase {

    private var collectionView: CollectionViewMock!
    private var subject: CategoriesDataSource!
    private var service: CategoryServiceMock!
    private var emptyHandler: EmptyCollectionViewHandling!

    override func setUp() {
        super.setUp()

        collectionView = CollectionViewMock()
        service = CategoryServiceMock()
        emptyHandler = EmptyCollectionViewHandler(modeToRenderable: [:])
        service = CategoryServiceMock()

        subject = CategoriesDataSource(service: service, emptyTableHandler: emptyHandler)
    }

    func test_use_configuresCollectionView() {
        subject.use(collectionView)

        XCTAssertTrue(collectionView.dataSourceDidSet)
        XCTAssertTrue(collectionView.didSetDelegation)
    }
}
