//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol DataUpdateListening: class {
    func willStartDataLoading()
    func didFinishDataLoading()
}

final class BrandsViewController: UIViewController, HavingNib {
    static let nibName: String = "BrandsViewController"

    fileprivate let interactor: BrandsInteracting

    @IBOutlet fileprivate weak var brandsCollection: UICollectionView!
    fileprivate let refreshControl = UIRefreshControl()

    init(interactor: BrandsInteracting) {
        self.interactor = interactor
        super.init(nibName: BrandsViewController.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresh()
        interactor.use(brandsCollection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadData()
    }
}

extension BrandsViewController {
    fileprivate func setUpRefresh() {
        refreshControl.tintColor = UIColor.rouge
        refreshControl.addTarget(self, action: #selector(BrandsViewController.refresh), for: .valueChanged)
        brandsCollection.addSubview(refreshControl)
    }

    @objc fileprivate func refresh() {
        interactor.loadData()
    }
}

extension BrandsViewController: DataUpdateListening {
    func willStartDataLoading() {
        refreshControl.beginRefreshing()
    }

    func didFinishDataLoading() {
        refreshControl.endRefreshing()
    }
}
