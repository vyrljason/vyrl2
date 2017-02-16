//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension ReusableView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView {}

extension UICollectionView {
    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell where Cell: ReusableView {
        let cellIdentifier = Cell.reusableIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            return Cell()
        }
        return cell
    }
}
