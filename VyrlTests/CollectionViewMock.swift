//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CollectionViewMock: UICollectionView {

    var delegateDidSet = false
    var dataSourceDidSet = false
    var reloadDidCall = false

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var delegate: UICollectionViewDelegate? {
        didSet {
            delegateDidSet = true
        }
    }

    override var dataSource: UICollectionViewDataSource? {
        didSet {
            dataSourceDidSet = true
        }
    }

    override func reloadData() {
        reloadDidCall = true
    }
}
