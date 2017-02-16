//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BrandsViewController: UIViewController, HavingNib {
    static let nibName: String = "BrandsViewController"

    @IBOutlet fileprivate weak var brandsCollection: UICollectionView!

    init() {
        super.init(nibName: BrandsViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
