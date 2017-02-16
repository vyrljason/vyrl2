//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class LeftMenuViewController: UIViewController, HavingNib {
    
    static let nibName: String = "LeftMenuViewController"

    init() {
        super.init(nibName: LeftMenuViewController.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
