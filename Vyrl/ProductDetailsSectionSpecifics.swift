//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

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
