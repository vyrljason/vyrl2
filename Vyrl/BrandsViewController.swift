//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol DataLoadingEventsListening: class {
    func willStartDataLoading()
    func didFinishDataLoading()
}

final class BrandsViewController: UIViewController, HavingNib {
    static let nibName: String = "BrandsViewController"

    fileprivate let interactor: BrandsInteracting & DataRefreshing

    @IBOutlet fileprivate weak var brandsCollection: UICollectionView!
    fileprivate let refreshControl = UIRefreshControl()

    init(interactor: BrandsInteracting & DataRefreshing) {
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
        refreshControl.addTarget(interactor, action: #selector(DataRefreshing.refreshData), for: .valueChanged)
        brandsCollection.addSubview(refreshControl)
    }
}

extension BrandsViewController: DataLoadingEventsListening {
    func willStartDataLoading() {
        refreshControl.beginRefreshing()
    }

    func didFinishDataLoading() {
        refreshControl.endRefreshing()
    }
}
