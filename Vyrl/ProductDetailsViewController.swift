//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ProductDetailsViewController: UITableViewController, HavingNib {
    static let nibName: String = "ProductDetailsViewController"
    
    fileprivate let interactor: ProductDetailsInteracting
    
    @IBOutlet fileprivate weak var productDetailsTableView: UITableView!

    init(interactor: ProductDetailsInteracting) {
        self.interactor = interactor
        super.init(nibName: ProductDetailsViewController.nibName, bundle: nil)
        self.interactor.errorPresenter = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        interactor.use(productDetailsTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear(animated)
    }
}
