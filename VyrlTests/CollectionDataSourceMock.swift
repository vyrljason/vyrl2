//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

class CollectionDataSourceMock: NSObject, CollectionViewManaging, CollectionViewNibRegistering, CollectionViewUsing {
    weak var collectionViewControllingDelegate: (CollectionViewHaving & CollectionViewControlling)?
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
