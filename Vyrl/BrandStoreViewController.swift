//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BrandStoreViewController: UIViewController, HavingNib {
    static let nibName: String = "BrandStoreViewController"

    fileprivate let interactor: BrandStoreInteracting
    
    init(interactor: BrandStoreInteracting) {
        self.interactor = interactor
        super.init(nibName: BrandStoreViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
