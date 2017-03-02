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
    
    func dequeueHeader<Header: UICollectionReusableView>(at indexPath: IndexPath) -> Header where Header: ReusableView {
        let headerIdentifier = Header.reusableIdentifier
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? Header else {
            return Header()
        }
        return header
    }
}

extension UITableViewCell: ReusableView {}

extension UITableView {
    func dequeueCell<Cell: UITableViewCell>(at indexPath: IndexPath) -> Cell where Cell: ReusableView {
        let cellIdentifier = Cell.reusableIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            return Cell()
        }
        return cell
    }
}
