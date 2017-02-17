//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BrandsViewController: UIViewController, HavingNib {
    static let nibName: String = "BrandsViewController"

    fileprivate let interactor: BrandsInteracting
    
    @IBOutlet fileprivate weak var brandsCollection: UICollectionView!

    init(interactor: BrandsInteracting) {
        self.interactor = interactor
        super.init(nibName: BrandsViewController.nibName, bundle: nil)
        interactor.presenter = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.use(brandsCollection)
        interactor.loadData(refresh: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
