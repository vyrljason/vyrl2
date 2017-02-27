//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CartViewController: UIViewController, HavingNib {

    private enum Constants {
        static let title = NSLocalizedString("YOUR CART", comment: "")
    }

    static var nibName: String = "CartViewController"

    private let interactor: CartInteracting
    @IBOutlet private weak var collectionView: UICollectionView!

    init(interactor: CartInteracting) {
        self.interactor = interactor
        super.init(nibName: CartViewController.nibName, bundle: nil)
        title = Constants.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        interactor.use(collectionView)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        interactor.viewDidAppear()
    }
}
