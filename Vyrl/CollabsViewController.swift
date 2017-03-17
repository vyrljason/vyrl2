//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CollabsViewController: UIViewController, HavingNib {
    static var nibName: String = "CollabsViewController"
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate var interactor: CollabsInteracting & DataRefreshing
    fileprivate let refreshControl = UIRefreshControl()

    init(interactor: CollabsInteracting & DataRefreshing) {
        self.interactor = interactor
        super.init(nibName: CollabsViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresh()
        interactor.use(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
    }
}

extension CollabsViewController {
    fileprivate func setUpRefresh() {
        refreshControl.tintColor = UIColor.rouge
        refreshControl.addTarget(interactor, action: #selector(DataRefreshing.refreshData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
}

extension CollabsViewController: DataLoadingEventsListening {
    func willStartDataLoading() {
        refreshControl.beginRefreshing()
    }

    func didFinishDataLoading() {
        refreshControl.endRefreshing()
    }
}
