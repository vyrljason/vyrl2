//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Fakery

// MARK: - Mocks

final class FlowLayoutHandlerMock: BrandStoreFlowLayoutHandling {
    var headerSize: CGSize = CGSize.zero
    func use(_ collectionView: UICollectionView) { }
}

final class ServiceMock: ProductsProviding {
    var success = true
    var isResponseEmpty = false
    var products: [Product] = Array(repeating: VyrlFaker.faker.product(), count: 5)
    let error: ServiceError = .unknown
    
    func get(completion: @escaping (Result<[Product], ServiceError>) -> Void) {
        if success {
            completion(.success( isResponseEmpty ? [] : products ))
        } else {
            completion(.failure(error))
        }
    }
}

final class InteractorMock: CollectionViewHaving, CollectionViewControlling {
    var collectionView: UICollectionView?
    var updateResult: DataFetchResult?
    
    func updateCollection(with result: DataFetchResult) {
        updateResult = result
    }
    func loadData() { }
}

// MARK: - Tests

final class BrandStoreDataSourceTest: XCTestCase {
    var brand: Brand!
    var flowLayoutHandlerMock = FlowLayoutHandlerMock()
    var collectionViewMock = CollectionViewMock()
    var serviceMock = ServiceMock()
    var interactorMock = InteractorMock()
    var subject: BrandStoreDataSource!
    
    override func setUp() {
        super.setUp()
        brand = VyrlFaker.faker.brand()
        interactorMock.collectionView = collectionViewMock
        subject = BrandStoreDataSource(brand: brand, service: serviceMock, flowLayoutHandler: flowLayoutHandlerMock)
        subject.delegate = interactorMock
    }
    
    func test_whenServiceReturnsNonEmptyData_updatesDelegate() {
        serviceMock.success = true
        serviceMock.isResponseEmpty = false
        
        subject.loadData()
        
        XCTAssertTrue(interactorMock.updateResult == .someData)
    }
    
    func test_whenServiceReturnsEmptyData_updatesDelegate() {
        serviceMock.success = true
        serviceMock.isResponseEmpty = true
        
        subject.loadData()
        
        XCTAssertTrue(interactorMock.updateResult == .empty)
    }
    
    func test_whenServiceReturnsError_updatesDelegate() {
        serviceMock.success = false
        
        subject.loadData()
        
        XCTAssertTrue(interactorMock.updateResult == .error)
    }
    
    func test_returnRightSectionsCount() {
        let expectedSectionCount: Int = 1
        let sectionCount: Int = subject.numberOfSections(in: interactorMock.collectionView!)
        XCTAssertEqual(sectionCount, expectedSectionCount)
    }
    
    func test_returnRightItemCount() {
        let expectedItemCount: Int = serviceMock.products.count
        subject.loadData()
        
        let itemCount: Int = subject.collectionView(interactorMock.collectionView!, numberOfItemsInSection: 0)
        
        XCTAssertEqual(itemCount, expectedItemCount)
    }
}

// MARK: - End
