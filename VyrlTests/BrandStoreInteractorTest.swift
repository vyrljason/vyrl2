//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

// MARK: - Mocks

final class ProductDetailsPresenterMock: ProductDetailsPresenting {
    var didCallPresentProductDetails = false
    var productArgument: Product?
    
    func presentProductDetails(for product: Product, animated: Bool) {
        didCallPresentProductDetails = true
        productArgument = product
    }
}

final class BrandStoreDataSourceMock: NSObject, BrandStoreDataProviding {
    weak var collectionViewControllingDelegate: CollectionViewHaving & CollectionViewControlling?
    weak var selectionDelegate: ProductSelecting?
    var didRegisterNibs = false
    var didLoadData = false
    var didUseCollectionView = false
    
    func registerNibs(in collectionView: UICollectionView) {
        didRegisterNibs = true
    }
    
    func loadData() {
        didLoadData = true
    }
    
    func use(_ collectionView: UICollectionView) {
        didUseCollectionView = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - Tests

final class BrandStoreInteractorTest: XCTestCase {
    
    var subject: BrandStoreInteractor!
    var dataSourceMock: BrandStoreDataSourceMock!
    var collectionViewMock = CollectionViewMock()
    var presenterMock = ProductDetailsPresenterMock()
    
    override func setUp() {
        presenterMock = ProductDetailsPresenterMock()
        dataSourceMock = BrandStoreDataSourceMock()
        subject = BrandStoreInteractor(dataSource: dataSourceMock)
        subject.productDetailsPresenter = presenterMock
    }
    
    func test_use_registersNibs() {
        subject.use(collectionViewMock)
        
        XCTAssertTrue(dataSourceMock.didRegisterNibs)
    }
    
    func test_use_setsDataSourceAndDelegate() {
        subject.use(collectionViewMock)
        
        XCTAssertTrue(collectionViewMock.didSetDelegation)
        XCTAssertTrue(collectionViewMock.dataSourceDidSet)
        XCTAssertTrue(dataSourceMock.didUseCollectionView)
    }
    
    func test_use_setsCollectionViewOnDataSource() {
        subject.use(collectionViewMock)
        
        XCTAssertTrue(dataSourceMock.didUseCollectionView)
    }
    
    func test_loadData_callsDataSourceLoadData() {
        subject.loadData()
        
        XCTAssertTrue(dataSourceMock.didLoadData)
    }
    
    func test_updateCollection_reloadsCollectionViewInAllCases() {
        subject.use(collectionViewMock)
        let possibleResults = [DataFetchResult.someData, DataFetchResult.empty, DataFetchResult.error]
        
        for result in possibleResults {
            collectionViewMock.reloadDidCall = false
            subject.updateCollection(with: result)
            XCTAssertTrue(collectionViewMock.reloadDidCall)
        }
    }
    
    func test_didSelect_callsStorePresenter() {
        let product = VyrlFaker.faker.product()
        
        subject.didSelect(product: product)
        
        XCTAssertTrue(presenterMock.didCallPresentProductDetails)
        guard let presenterArgument: Product = presenterMock.productArgument else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(presenterArgument.id, product.id)
    }
}

// MARK: - End
