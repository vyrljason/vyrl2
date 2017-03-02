//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ReloadingData: class {
    func reloadData()
}

extension UITableView: ReloadingData { }
extension UICollectionView: ReloadingData { }
