//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class BrandStoreInteractorMock: BrandStoreInteracting {
    var collectionView: UICollectionView?
    weak var productDetailsPresenter: ProductDetailsPresenting?
    func use(_ collectionView: UICollectionView) { }
    func updateCollection(with result: DataFetchResult) { }
    func loadData() { }
    func didSelect(product: Product) { }
}

final class BrandsInteractorMock: BrandsInteracting, DataRefreshing {
    var collectionView: UICollectionView?
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var brandStorePresenter: BrandStorePresenting?
    func refreshData() { }
    func updateCollection(with result: DataFetchResult) { }
    func loadData() { }
    func use(_ collectionView: UICollectionView) { }
    func didSelect(brand: Brand) { }
}

final class ProductDetailsInteractorMock: ProductDetailsInteracting {
    weak var tableView: UITableView?
    func use(_ tableView: UITableView) { }
    func updateTable(with result: DataFetchResult) { }
    func loadTableData() { }
    func viewWillAppear(_ animated: Bool) { }
    func addToCart() { }
}

final class BrandsFactoryMock: BrandsControllerMaking {
    static func make(storePresenter: BrandStorePresenting, interactor: BrandsInteracting & DataRefreshing) -> BrandsViewController {
        return BrandsViewController(interactor: interactor)
    }
}

final class BrandStoreFactoryMock: BrandStoreMaking {
    static func make(brand: Brand, presenter: ProductDetailsPresenting) -> BrandStoreViewController {
        return BrandStoreViewController(interactor: BrandStoreInteractorMock())
    }
}

final class ProductDetailsFactoryMock: ProductDetailsMaking {
    static func make(product brand: Product) -> ProductDetailsViewController {
        return ProductDetailsViewController(interactor: ProductDetailsInteractorMock())
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
                                   productDetailsFactory: ProductDetailsFactoryMock.self,
                                   navigationController: navigationController)

    }

    func test_presentStore_setsBrandStoreViewControllerAsTopViewController() {
        let brand = VyrlFaker.faker.brand()

        subject.presentStore(for: brand, animated: false)

        XCTAssertTrue(navigationController.pushed is BrandStoreViewController)
    }
    
    func test_presentProductDetails_pushesProductDetailsViewController() {
        let product = VyrlFaker.faker.product()
        
        subject.presentProductDetails(for: product, animated: false)
        
        XCTAssertTrue(navigationController.pushed is ProductDetailsViewController)
    }
}
