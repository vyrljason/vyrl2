//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol LoadingDataForCollectionView: class, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var delegate: CollectionViewHaving & CollectionViewControlling? { get set }
    func loadData(refresh: Bool)
    func registerNibs()
}
