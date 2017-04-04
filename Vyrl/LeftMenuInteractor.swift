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
    private let chatCredentialsStorage: ChatCredentialsStoring
    private let unreadMessagesObserver: UnreadMessagesObserving

    init(dataSource: CollectionViewUsing & CategoriesSelectionDelegateHaving & UICollectionViewDelegate & UICollectionViewDataSource,
         credentialsProvider: APICredentialsProviding,
         chatCredentialsStorage: ChatCredentialsStoring,
         unreadMessagesObserver: UnreadMessagesObserving) {
        self.dataSource = dataSource
        self.credentialsProvider = credentialsProvider
        self.chatCredentialsStorage = chatCredentialsStorage
        self.unreadMessagesObserver = unreadMessagesObserver
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
        chatCredentialsStorage.clear()
        unreadMessagesObserver.stopObserving()
        delegate?.showAuthorization()
    }
}
