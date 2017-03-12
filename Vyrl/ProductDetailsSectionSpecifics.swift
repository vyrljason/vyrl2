//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let variantsHeader: String = NSLocalizedString("Pick variants", comment: "")
    static let contentGuidelines: String = NSLocalizedString("Content guidelines", comment: "")
    static let headerRowOffset: Int = 1
}

protocol SectionRenderer: NibRegisteringInTableView {
    weak var dataAccessor: ProductDetailsDataAccessing! { get set }
    func rows() -> Int
    func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell
    func shouldHighlight(row: Int) -> Bool
    func didSelect(table: UITableView, indexPath: IndexPath)
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
    
    func didSelect(table: UITableView, indexPath: IndexPath) { }
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
        let isButtonEnabled = dataAccessor.interactor?.allVariantsArePicked ?? false
        cell.render(AddToCartTableCellRenderable(enabled: isButtonEnabled))
        return cell
    }
    
    override func shouldHighlight(row: Int) -> Bool {
        return true
    }
    
    override func didSelect(table: UITableView, indexPath: IndexPath) {
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
        let variantsCount = variantHandler.variantsCount
        return variantsCount > 0 ? variantsCount + Constants.headerRowOffset : 0
    }
    
    override func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: TableHeaderCell = tableView.dequeueCell(at: indexPath)
            cell.render(TableHeaderRenderable(text: Constants.variantsHeader, mandatory: true))
            return cell
        } else {
            let cell: DetailTableViewCell = tableView.dequeueCell(at: indexPath)
            let index = variantIndex(for: indexPath)
            cell.render(variantHandler.renderable(forIndex: index))
            return cell
        }
    }
    
    override func shouldHighlight(row: Int) -> Bool {
        return row != 0
    }
    
    override func didSelect(table: UITableView, indexPath: IndexPath) {
        let index = variantIndex(for: indexPath)
        guard let possibleVariants = variantHandler.possibleVariants(forIndex: index) else { return }
        guard let cell = table.cellForRow(at: indexPath) as? DetailTableViewCell else {
            return
        }
        dataAccessor.interactor?.selectFromVariants(possibleVariants, on: cell.detail)
    }
    
    private func variantIndex(for indexPath: IndexPath) -> Int {
        return indexPath.row - Constants.headerRowOffset
    }
}

final class ContentGuidelinesRenderer: CommonRenderer {
    
    override func registerNibs(in tableView: UITableView) {
        TableHeaderCell.register(to: tableView)
        TextTableCell.register(to: tableView)
    }
    
    override func rows() -> Int {
        let rows = dataAccessor.product.isAdditionalGuidelines ? 2 : 0
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: TableHeaderCell = tableView.dequeueCell(at: indexPath)
            cell.render(TableHeaderRenderable(text: Constants.contentGuidelines, mandatory: false))
            return cell
        } else {
            let cell: TextTableCell = tableView.dequeueCell(at: indexPath)
            cell.render(TextTableCellRenderable(text: dataAccessor.product.additionalGuidelines ?? ""))
            return cell
        }
    }
}

final class DescriptionRenderer: CommonRenderer {
    
    override func registerNibs(in tableView: UITableView) {
        ExpandableTextTableCell.register(to: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        let cell: ExpandableTextTableCell = tableView.dequeueCell(at: indexPath)
        cell.render(ExpandableTextTableCellRenderable(text: dataAccessor.product.description, initiallyExpanded: false))
        return cell
    }
    
    override func shouldHighlight(row: Int) -> Bool {
        return true
    }
    
    override func didSelect(table: UITableView, indexPath: IndexPath) {
        guard let cell = table.cellForRow(at: indexPath) as? ExpandableTextTableCell else {
            return
        }
        cell.toggleExpand()
        forceReload(tableView: table)
    }
    
    private func forceReload(tableView: UITableView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

final class GalleryRenderer: CommonRenderer {
    
    let dataProvider: ProductDetailsGalleryDataProviding
    
    init(dataProvider: ProductDetailsGalleryDataProviding) {
        self.dataProvider = dataProvider
    }
    
    override func registerNibs(in tableView: UITableView) {
        SwipeableGalleryTableCell.register(to: tableView)
    }
    
    override func rows() -> Int {
        return dataProvider.imagesCount > 0 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        let cell: SwipeableGalleryTableCell = tableView.dequeueCell(at: indexPath)
        SwipeableGalleryItemCell.register(to: cell.collectionView)
        let imageCount = dataProvider.imagesCount
        cell.render(SwipeableGalleryTableCellRenderable(imageCount: imageCount))
        cell.useDataProvider(provider: dataProvider)
        return cell
    }
}
