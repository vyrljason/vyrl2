//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CollectionViewMock: UICollectionView {

    var didSetDelegation = false
    var dataSourceDidSet = false
    var reloadDidCall = false
    var didRegisterNib = false

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override weak var delegate: UICollectionViewDelegate? {
        didSet {
            didSetDelegation = true
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

    override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        didRegisterNib = true
    }
}
