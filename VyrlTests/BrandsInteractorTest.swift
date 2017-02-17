//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandsDataSourceMock: NSObject, CollectionViewDataProviding, CollectionViewNibRegistering {

    weak var delegate: CollectionViewHaving & CollectionViewControlling?
    var didLoad = false
    var didRegisterNibs = false

    func loadData() {
        didLoad = true
    }

    func registerNibs() {
        didRegisterNibs = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

final class BrandsInteractorTest: XCTestCase {

    var collectionView: CollectionViewMock!
    var dataSource: BrandsDataSourceMock!
    var subject: BrandsInteractor!

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        dataSource = BrandsDataSourceMock()
        subject = BrandsInteractor(dataSource: dataSource)
        dataSource.delegate = subject
    }

    func test_use_setsDelegateDataSourceAndRegisterNibs() {

        subject.use(collectionView)

        XCTAssertTrue(collectionView.delegateDidSet)
        XCTAssertTrue(collectionView.dataSourceDidSet)
        XCTAssertTrue(dataSource.didRegisterNibs)
    }

    func test_loadData_callsDataSource() {
        subject.loadData()

        XCTAssertTrue(dataSource.didLoad)
    }

    func test_reloadData_reloadsCollectionView() {
        subject.use(collectionView)

        subject.reloadData()

        XCTAssertTrue(collectionView.reloadDidCall)
    }
}
