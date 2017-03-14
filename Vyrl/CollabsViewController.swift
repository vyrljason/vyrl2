//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CollabsViewController: UIViewController, HavingNib {
    static var nibName: String = "CollabsViewController"
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var interactor: CollabsInteracting
    init(interactor: CollabsInteracting) {
        self.interactor = interactor
        super.init(nibName: CollabsViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.use(tableView)
//        addEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
    }
    
    private func addEmptyView() {
        let emptyView = CollabsEmptyView.fromNib()
        view.addSubview(emptyView)
        view.topAnchor.constraint(equalTo: emptyView.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor).isActive = true
    }
}
