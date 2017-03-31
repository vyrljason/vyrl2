//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum ProductDetailsSections: Int {
    case Gallery = 0
    case NameAndPrice
    case Description
    case Variants
    case ContentGuidelines
    case Cart
    
    static func count() -> Int {
        let lastValue = ProductDetailsSections.Cart
        return lastValue.rawValue + 1
    }
    
    var integerValue: Int {
        return rawValue
    }
}

protocol ProductDetailsDataAccessing: class {
    var product: Product { get }
    weak var interactor: ProductDetailsInteracting? { get set }
}

protocol ProductDetailsDataProviding: TableViewUsing, TableViewHaving, TableViewDataProviding, ProductDetailsDataAccessing { }

final class ProductDetailsDataSource: NSObject, ProductDetailsDataProviding {
    weak var tableView: UITableView?
    weak var interactor: ProductDetailsInteracting?
    let product: Product
    fileprivate var emptyRenderer: SectionRenderer
    fileprivate var rendererMap: [Int:SectionRenderer]
    
    init(product: Product, renderers: [Int:SectionRenderer]) {
        self.product = product
        emptyRenderer = EmptyRenderer()
        rendererMap = renderers
        super.init()
        setupSections()
    }
    
    private func setupSections() {
        emptyRenderer.dataAccessor = self
        for (_, var renderer) in rendererMap {
            renderer.dataAccessor = self
        }

    }
    
    fileprivate func getRenderer(for section: Int) -> SectionRenderer {
        guard let renderer = rendererMap[section] else { return emptyRenderer }
        return renderer
    }
}

extension ProductDetailsDataSource: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        registerNibs(in: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ProductDetailsDataSource: NibRegisteringInTableView {
    func registerNibs(in tableView: UITableView) {
        for (_, renderer) in rendererMap {
            renderer.registerNibs(in: tableView)
        }
    }
}

extension ProductDetailsDataSource: TableViewDataProviding {
    
    func loadTableData() {
         // Currently fetching is not needed
        DispatchQueue.onMainThread { [weak self] in
            guard let `self` = self else { return }
            self.updateTable(with: .empty)
        }
    }

    func updateTable(with result: DataFetchResult) {
        tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let renderer = getRenderer(for: indexPath.section)
        return renderer.tableView(tableView, cellFor: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRenderer(for: section).rows()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProductDetailsSections.count()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return getRenderer(for: indexPath.section).shouldHighlight(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getRenderer(for: indexPath.section).didSelect(table: tableView, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
