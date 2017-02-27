//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class DataSourceMock: NSObject,
                            CollectionViewUsing,
                            CategoriesSelectionDelegateHaving,
                            UICollectionViewDelegate,
                            UICollectionViewDataSource {

    weak var delegate: CategorySelectionHandling?

    var collectionView: UICollectionView?

    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
