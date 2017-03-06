//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct CartSummaryRenderable {
    let summary: String
    let price: String
    let summaryVisible: Bool

    init(from model: CartSummary) {
        summaryVisible = model.productsCount > 0
        price = model.value.asMoneyWithDecimals
        let summaryFormat = NSLocalizedString("cart.summaryFormat", comment: "") as NSString
        summary = NSString(format: summaryFormat, model.productsCount, model.brandsCount) as String
    }
}

protocol CartSummaryRendering: class {
    func render(_ renderable: CartSummaryRenderable)
}

final class CartViewController: UIViewController, HavingNib {

    private enum Constants {
        static let title = NSLocalizedString("cart.title", comment: "")
    }

    static var nibName: String = "CartViewController"

    fileprivate let interactor: CartInteracting & DataRefreshing

    @IBOutlet fileprivate weak var summaryLabel: UILabel!
    @IBOutlet fileprivate weak var price: UILabel!
    @IBOutlet fileprivate weak var summaryView: UIView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var requestButton: UIButton!

    fileprivate let refreshControl = UIRefreshControl()

    init(interactor: CartInteracting & DataRefreshing) {
        self.interactor = interactor
        super.init(nibName: CartViewController.nibName, bundle: nil)
        title = Constants.title
        interactor.projector = self
        automaticallyAdjustsScrollViewInsets = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        interactor.use(tableView)
        setUpRefresh()
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setEditing(false, animated: false)
    }

    @IBAction private func didTapRequest() {
        interactor.didTapRequest()
    }
}

extension CartViewController: CartSummaryRendering {
    func render(_ renderable: CartSummaryRenderable) {
        summaryView.isHidden = !renderable.summaryVisible
        requestButton.isHidden = !renderable.summaryVisible
        price.text = renderable.price
        summaryLabel.text = renderable.summary
    }
}

extension CartViewController {
    fileprivate func setUpRefresh() {
        refreshControl.tintColor = UIColor.rouge
        refreshControl.addTarget(interactor, action: #selector(DataRefreshing.refreshData), for: .valueChanged)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(refreshControl)
    }
}

extension CartViewController: DataLoadingEventsListening {
    func willStartDataLoading() {
        refreshControl.beginRefreshing()
    }

    func didFinishDataLoading() {
        refreshControl.endRefreshing()
    }
}
