//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Fakery

// MARK: - Mocks

final class ProductDetailsDataSourceMock: NSObject, ProductDetailsDataProviding {
    var didUseTableView: Bool = false
    var didUseLoadTableData: Bool = false
    var didUseRegisterNibs: Bool = false
    var usedTableArgument: UITableView?
    weak var tableViewControllingDelegate: TableViewControlling?
    var product: Product = VyrlFaker.faker.product()
    weak var interactor: ProductDetailsInteracting?
    
    func use(_ tableView: UITableView) {
        didUseTableView = true
        usedTableArgument = tableView
    }
    
    func registerNibs(in tableView: UITableView) {
        didUseRegisterNibs = true
    }
    
    func loadTableData() {
        didUseLoadTableData = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

// MARK: - Tests

final class ProductDetailsInteractorTest: XCTestCase {
    
    var subject: ProductDetailsInteractor!
    var tableViewMock = TableViewMock()
    var dataSource: ProductDetailsDataSourceMock!

    override func setUp() {
        dataSource = ProductDetailsDataSourceMock()
        subject = ProductDetailsInteractor(dataSource: dataSource)
    }
    
    func test_onInit_setsTableViewDataProvidingDelegate() {
        XCTAssertTrue(dataSource.tableViewControllingDelegate === subject)
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
    
    func test_loadTableData_reloadsDataSource() {
        subject.loadTableData()
        
        XCTAssertTrue(dataSource.didUseLoadTableData)
    }
    
    func test_onViewWillAppear_loadsTableData() {
        let anyValue: Bool = false
        
        subject.viewWillAppear(anyValue)
        
        XCTAssertTrue(dataSource.didUseLoadTableData)
    }
    
    func test_use_forwardsUseToDataSource() {
        subject.use(tableViewMock)
        
        XCTAssertTrue(dataSource.didUseTableView)
        XCTAssertTrue(dataSource.usedTableArgument === tableViewMock)
    }
}

// MARK: - End
