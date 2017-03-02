//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartInteracting: class, TableViewUsing {
    weak var projector: CartSummaryRendering? { get set }
    func viewDidAppear()
}

final class CartInteractor: CartInteracting {

    fileprivate let dataSource: CartDataProviding
    fileprivate let emptyTableHandler: EmptyTableViewHandling

    weak var projector: CartSummaryRendering?

    init(dataSource: CartDataProviding, emptyTableHandler: EmptyTableViewHandling) {
        self.dataSource = dataSource
        self.emptyTableHandler = emptyTableHandler
        dataSource.emptyTableDelegate = emptyTableHandler
        dataSource.summaryDelegate = self
    }

    func viewDidAppear() {
        dataSource.loadData()
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
