//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartInteracting: class, TableViewUsing {
    weak var projector: CartSummaryRendering & ViewContainer & LayoutGuideHaving? { get set }
    func viewDidAppear()
}

protocol GuidelinesPresenting: class {
    func showGuidelines(for product: Product)
}

final class CartInteractor: CartInteracting {

    fileprivate enum Constants {
        static let guidelinesTitle = NSLocalizedString("cart.guidelines.title", comment: "")
        static let guidelinesButtonTitle = NSLocalizedString("cart.guidelines.buttonTitle", comment: "")
    }

    fileprivate let dataSource: CartDataProviding
    fileprivate let emptyTableHandler: EmptyTableViewHandling

    weak var projector: CartSummaryRendering & ViewContainer & LayoutGuideHaving?

    init(dataSource: CartDataProviding, emptyTableHandler: EmptyTableViewHandling) {
        self.dataSource = dataSource
        self.emptyTableHandler = emptyTableHandler
        dataSource.emptyTableDelegate = emptyTableHandler
        dataSource.summaryDelegate = self
        dataSource.guidelinesDelegate = self
    }

    func viewDidAppear() {
        dataSource.loadData()
    }
}

extension CartInteractor: GuidelinesPresenting {
    func showGuidelines(for product: Product) {
        let info = NSAttributedString(string: product.description, attributes: StyleKit.infoViewAttributes)
        let renderable = InfoViewRenderable(header: Constants.guidelinesTitle,
                                            info: info, // TODO: guidelines!
            actionButtonTitle: Constants.guidelinesButtonTitle)
        let presenter = InfoViewProjector(renderable: renderable)
        presenter.presenter = projector
        presenter.display()
    }
}

extension CartInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        emptyTableHandler.use(tableView)
        dataSource.use(tableView)
        dataSource.reloadingDelegate = tableView
    }
}

extension CartInteractor: SummaryUpdateHandling {
    func didUpdate(summary: CartSummary) {
        let renderable = CartSummaryRenderable(from: summary)
        projector?.render(renderable)
    }
}
