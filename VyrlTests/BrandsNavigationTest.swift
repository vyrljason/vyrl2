//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class BrandStoreInteractorMock: BrandStoreInteracting {
    var collectionView: UICollectionView?
    func use(_ collectionView: UICollectionView) { }
    func updateCollection(with result: DataFetchResult) { }
    func loadData() { }
}

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
    static func make(storePresenter: BrandStorePresenting, interactor: BrandsInteracting & CollectionViewRefreshing) -> BrandsViewController {
        return BrandsViewController(interactor: interactor)
    }
}

final class BrandStoreFactoryMock: BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController {
        return BrandStoreViewController(interactor: BrandStoreInteractorMock())
    }
}

final class BrandsNavigationTest: XCTestCase {

    private var navigationController: NavigationControllerMock!
    private var subject: BrandsNavigation!

    override func setUp() {
        super.setUp()
        navigationController = NavigationControllerMock()
        subject = BrandsNavigation(brandsInteractor: BrandsInteractorMock(),
                                   brandsFactory: BrandsFactoryMock.self,
                                   brandStoreFactory: BrandStoreFactoryMock.self,
                                   navigationController: navigationController)

    }

    func test_presentStore_setsBrandStoreViewControllerAsTopViewController() {
        let brand = VyrlFaker.faker.brand()

        subject.presentStore(for: brand, animated: false)

        XCTAssertTrue(navigationController.pushed is BrandStoreViewController)
    }
}
