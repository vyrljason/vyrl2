//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class BrandStoreInteractorMock: BrandStoreInteracting { }

final class BrandsInteractorMock: BrandsInteracting, CollectionViewRefreshing {
    var collectionView: UICollectionView?
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var brandStorePresenter: BrandStorePresenting?
    func refresh() { }
    func updateCollection(with result: DataFetchResult) { }
    func loadData() { }
    func use(_ collectionView: UICollectionView) { }
    func didSelect(brand: Brand) { }
}

final class BrandsFactoryMock: BrandsControllerMaking {
    static func make(storePresenter: BrandStorePresenting) -> BrandsViewController {
        return BrandsViewController(interactor: BrandsInteractorMock())
    }
}

final class BrandStoreFactoryMock: BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController {
        return BrandStoreViewController(interactor: BrandStoreInteractorMock())
    }
}

final class BrandsNavigationTest: XCTestCase {
    private var subject: BrandsNavigation!

    override func setUp() {
        super.setUp()
        subject = BrandsNavigation(brandsFactory: BrandsFactoryMock.self, brandStoreFactory: BrandStoreFactoryMock.self)

    }

    func test_presentStore_whenModallyIsFalse_setsBrandStoreViewControllerAsTopViewController() {
        let brand = VyrlFaker.faker.brand()

        subject.presentStore(for: brand, modally: false, animated: false)

        XCTAssertTrue(subject.navigationController.topViewController is BrandStoreViewController)
    }
}
