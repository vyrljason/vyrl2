//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let variantsHeader: String = NSLocalizedString("Pick variants", comment: "")
}

protocol SectionRenderer: NibRegisteringInTableView {
    weak var dataAccessor: ProductDetailsDataAccessing! { get set }
    func rows() -> Int
    func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell
    func shouldHighlight(row: Int) -> Bool
    func didSelectRow(row: Int)
}

class CommonRenderer: SectionRenderer {
    weak var dataAccessor: ProductDetailsDataAccessing!
    
    func rows() -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        fatalError("This should never be called")
    }
    
    func shouldHighlight(row: Int) -> Bool {
        return false
    }
    
    func registerNibs(in tableView: UITableView) { }
    
    func didSelectRow(row: Int) { }
}

final class EmptyRenderer: CommonRenderer {
    
    override func rows() -> Int {
        return 0
    }
}

final class AddToCartRenderer: CommonRenderer {
    
    override func registerNibs(in tableView: UITableView) {
        AddToCartTableCell.register(to: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        let cell: AddToCartTableCell = tableView.dequeueCell(at: indexPath)
        cell.render(AddToCartTableCellRenderable(enabled: true))
        return cell
    }
    
    override func shouldHighlight(row: Int) -> Bool {
        return true
    }
    
    override func didSelectRow(row: Int) {
        dataAccessor.interactor?.addToCart()
    }
}

final class NameAndPriceRenderer: CommonRenderer {
    
    override func registerNibs(in tableView: UITableView) {
        CenteredWithDetailTableCell.register(to: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        let cell: CenteredWithDetailTableCell = tableView.dequeueCell(at: indexPath)
        cell.render(NamePriceTableCellRenderable(product: dataAccessor.product))
        return cell
    }
}

final class VariantsRenderer: CommonRenderer {
    
    let variantHandler: VariantHandling
    
    init(variantHandler: VariantHandling) {
        self.variantHandler = variantHandler
    }
    
    override func registerNibs(in tableView: UITableView) {
        DetailTableViewCell.register(to: tableView)
        TableHeaderCell.register(to: tableView)
    }
    
    override func rows() -> Int {
        let variantsCount = variantHandler.variantsCount()
        return variantsCount > 0 ? variantsCount + 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: TableHeaderCell = tableView.dequeueCell(at: indexPath)
            cell.render(TableHeaderRenderable(text: Constants.variantsHeader))
            return cell
        } else {
            let cell: DetailTableViewCell = tableView.dequeueCell(at: indexPath)
            cell.render(renderable(for: indexPath))
            return cell
        }
    }
    
    override func shouldHighlight(row: Int) -> Bool {
        return row != 0
    }
    
    override func didSelectRow(row: Int) {
        let variants = variantHandler.allVariants[row - 1]
        dataAccessor.interactor?.selectFromVariants(variants)
    }
    
    private func renderable(for indexPath: IndexPath) -> DetailTableCellRenderable {
        let variant = variantHandler.selectedVariants[indexPath.row - 1]
        return DetailTableCellRenderable(text: variant.name, detail: variant.value, mandatory: true)
    }
}
