//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

@objc protocol LeftMenuInteracting: class {
    func didTapHome()
    func didTapAccount()
    func didTapLogout()
    func use(_ collectionView: UICollectionView)
}

protocol CategorySelectionHandling: class {
    func didSelect(category: Category)
}

final class LeftMenuInteractor: LeftMenuInteracting, CategorySelectionHandling {

    weak var delegate: (HomeScreenPresenting & CategoryPresenting & AccountScreenPresenting & AuthorizationScreenPresenting)?
    
    private let dataSource: CollectionViewUsing & CategoriesSelectionDelegateHaving & UICollectionViewDelegate & UICollectionViewDataSource
    private let credentialsProvider: APICredentialsProviding
    init(dataSource: CollectionViewUsing & CategoriesSelectionDelegateHaving & UICollectionViewDelegate & UICollectionViewDataSource,
         credentialsProvider: APICredentialsProviding) {
        self.dataSource = dataSource
        self.credentialsProvider = credentialsProvider
        dataSource.delegate = self
    }

    @objc func didTapHome() {
        delegate?.showHome()
    }

    @objc func didTapAccount() {
        delegate?.showAccount()
    }

    func use(_ collectionView: UICollectionView) {
        dataSource.use(collectionView)
    }

    func didSelect(category: Category) {
        delegate?.show(category)
    }

    func didTapLogout() {
        credentialsProvider.clear()
        delegate?.showAuthorization()
    }
}
