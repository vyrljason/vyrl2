//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CartViewController: UIViewController, HavingNib {

    static var nibName: String = "CartViewController"

    private let interactor: CartInteractor

    init(interactor: CartInteractor) {
        self.interactor = interactor
        super.init(nibName: CartViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
