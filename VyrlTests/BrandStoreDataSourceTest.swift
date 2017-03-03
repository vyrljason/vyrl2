//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Fakery

final class FlowLayoutHandlerMock: BrandStoreFlowLayoutHandling {
    var didGetHeaderSize: Bool = false
    var didGetItemSize: Bool = false
    var didUseCollectionView: Bool = false
    var didCallBrandStoreHeaderDel: Bool = false
    
    var headerSize: CGSize {
        didGetHeaderSize = true
        return CGSize.zero
    }
    var itemSize: CGSize {
        didGetItemSize = true
        return CGSize.zero
    }
    
    func use(_ collectionView: UICollectionView) {
        didUseCollectionView = true
    }
    func headerDidChangeHeight(height: CGFloat) {
        didCallBrandStoreHeaderDel = true
    }
}

final class ServiceMock: ProductsProviding {
    var success = true
    var isResponseEmpty = false
    var products: [Product] = Array(repeating: VyrlFaker.faker.product(), count: 5)
    let error: ServiceError = .unknown
    var brand: Brand?

    func getProducts(for brand: Brand, completion: @escaping (Result<[Product], ServiceError>) -> Void) {
        self.brand = brand
        if success {
            completion(.success( isResponseEmpty ? [] : products ))
        } else {
            completion(.failure(error))
        }
    }
}

final class InteractorMock: CollectionViewHaving, CollectionViewControlling, ProductSelecting {
    var collectionView: UICollectionView?
    var updateResult: DataFetchResult?
    var calledDidSelect: Bool = false
    var productArgument: Product?
    
    func updateCollection(with result: DataFetchResult) {
        updateResult = result
    }
    func loadData() { }
    
    func didSelect(product: Product) {
        calledDidSelect = true
        productArgument = product
    }
}

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
        subject.collectionViewControllingDelegate = interactorMock
        subject.selectionDelegate = interactorMock
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
    
    func test_flowLayoutDelegate_queryItemSize() {
        let anyLayout = UICollectionViewFlowLayout()
        let anyItem = IndexPath(item: 0, section: 0)
        let returnedSize = subject.collectionView(collectionViewMock, layout: anyLayout, sizeForItemAt: anyItem)
        
        XCTAssertTrue(flowLayoutHandlerMock.didGetItemSize)
        XCTAssertEqual(returnedSize, CGSize.zero)
    }
    
    func test_flowLayoutDelegate_queryHeaderSize() {
        let anyLayout = UICollectionViewFlowLayout()
        let anySection: Int = 0
        let returnedSize = subject.collectionView(collectionViewMock, layout: anyLayout, referenceSizeForHeaderInSection: anySection)
        
        XCTAssertTrue(flowLayoutHandlerMock.didGetHeaderSize)
        XCTAssertEqual(returnedSize, CGSize.zero)
    }
    
    func test_useCollectionView() {
        subject.use(collectionViewMock)
        
        XCTAssertTrue(flowLayoutHandlerMock.didUseCollectionView)
    }
    
    func test_onItemSelect_callSelectDelegate() {
        let indexPath = IndexPath(item: 0, section: 0)
        subject.loadData()
        
        subject.collectionView(collectionViewMock, didSelectItemAt: indexPath)
        
        XCTAssertTrue(interactorMock.calledDidSelect)
        guard let argument: Product = interactorMock.productArgument else {
            XCTFail()
            return
        }
        XCTAssertEqual(argument.id, serviceMock.products[0].id)
    }
}
