//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Fakery

// MARK - Mocks

class RendererMock: SectionRenderer {
    var didCallRegisterNibs: Bool = false
    var usedRegisterNibsArgument: UITableView?
    weak var dataAccessor: ProductDetailsDataAccessing!
    
    func rows() -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellFor indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func shouldHighlight(row: Int) -> Bool {
        return false
    }
    
    func registerNibs(in tableView: UITableView) {
        didCallRegisterNibs = true
        usedRegisterNibsArgument = tableView
    }
    
    func didSelect(table: UITableView, indexPath: IndexPath) { }
}

final class ProductDetailsDataSourceTest: XCTestCase {
    
    var product = VyrlFaker.faker.product()
    var tableViewMock: TableViewMock!
    var subject: ProductDetailsDataSource!
    var rendererMock: RendererMock!
    
    override func setUp() {
        rendererMock = RendererMock()
        tableViewMock = TableViewMock()
        subject = ProductDetailsDataSource(product: product, renderers: [0: rendererMock])
    }
    
    func test_use_registersNibs() {
        subject.use(tableViewMock)
        
        XCTAssertTrue(rendererMock.didCallRegisterNibs)
        XCTAssertTrue(rendererMock.usedRegisterNibsArgument === tableViewMock)
    }
    
    func test_use_setsDelegateAndDataSource_onTableView() {
        subject.use(tableViewMock)
        
        XCTAssertTrue(tableViewMock.didSetDataSource)
        XCTAssertTrue(tableViewMock.dataSource === subject)
        XCTAssertTrue(tableViewMock.didSetDelegation)
        XCTAssertTrue(tableViewMock.delegate === subject)
    }

    func test_updateTable_reloadsTableViewInAllCases() {
        subject.use(tableViewMock)
        let possibleResults = [DataFetchResult.someData, DataFetchResult.empty, DataFetchResult.error]

        for result in possibleResults {
            tableViewMock.didCallReload = false
            subject.updateTable(with: result)
            XCTAssertTrue(tableViewMock.didCallReload)
        }
    }
}
