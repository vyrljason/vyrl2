//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ReloadingData: class {
    func reloadData()
}

extension UICollectionView: ReloadingData { }
