//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

// MARK: - Mocks

final class BrandStoreDataSourceMock: NSObject, CollectionViewDataProviding, CollectionViewNibRegistering, CollectionViewUsing {
    weak var delegate: CollectionViewHaving & CollectionViewControlling?
    var didRegisterNibs = false
    var didLoadData = false
    var didUseCollectionView = false
    
    func registerNibs() {
        didRegisterNibs = true
    }
    
    func loadData() {
        didLoadData = true
    }
    
    func use(_ collectionView: UICollectionView) {
        didUseCollectionView = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 // to reviewer: Is there a way to implement this as an extension of the UICollectionViewDataSource protocol? Tried with no success.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell() // to reviewer: Is there a way to implement this as an extension of the UICollectionViewDataSource protocol? Tried with no success.
    }
}

// MARK: - Tests

final class BrandStoreInteractorTest: XCTest {
    
    var subject: BrandStoreInteractor!
    var dataSourceMock: BrandStoreDataSourceMock!
    var collectionViewMock = CollectionViewMock()
    
    override func setUp() {
        dataSourceMock = BrandStoreDataSourceMock()
        subject = BrandStoreInteractor(dataSource: dataSourceMock)
    }
    
    func test_use_registersNibs() {
        subject.use(collectionViewMock)
        
        XCTAssertTrue(dataSourceMock.didRegisterNibs)
    }
    
    func test_use_setsDataSourceAndDelegate() {
        subject.use(collectionViewMock)
        
        XCTAssertTrue(collectionViewMock.didSetDelegation)
        XCTAssertTrue(collectionViewMock.dataSourceDidSet)
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
}

// MARK: - End
