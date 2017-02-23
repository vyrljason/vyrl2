//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

@objc protocol LeftMenuInteracting: class {
    func didTapHome()
    func didTapAccount()
    func use(_ collectionView: UICollectionView)
}

protocol CategorySelectionHandling: class {
    func didSelect(category: Category)
}

final class LeftMenuInteractor: LeftMenuInteracting, CategorySelectionHandling {

    weak var delegate: HomeScreenPresenting & CategoryPresenting?
    
    private let dataSource: CollectionViewUsing & CategoriesSelectionDelegateHaving & UICollectionViewDelegate & UICollectionViewDataSource

    init(dataSource: CollectionViewUsing & CategoriesSelectionDelegateHaving & UICollectionViewDelegate & UICollectionViewDataSource) {
        self.dataSource = dataSource
        dataSource.delegate = self
    }

    @objc func didTapHome() {
        delegate?.showHome()
    }

    @objc func didTapAccount() {
        delegate?.showHome() // FIXME: Show account
    }

    func use(_ collectionView: UICollectionView) {
        dataSource.use(collectionView)
    }

    func didSelect(category: Category) {
        delegate?.show(category)
    }
}
