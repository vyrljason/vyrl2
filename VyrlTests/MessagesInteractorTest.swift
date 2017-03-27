//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesDataSourceMock: NSObject, MessagesDataProviding {
    var didUseTableView: Bool = false
    var didUseLoadTableData: Bool = false
    var didUseRegisterNibs: Bool = false
    var usedTableArgument: UITableView?
    weak var tableViewControllingDelegate: TableViewControlling?
    weak var reloadingDelegate: ReloadingData?
    weak var interactor: MessagesInteracting?
    
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

final class MessagesInteractorTest: XCTestCase {
    
    var subject: MessagesInteractor!
    var tableView = TableViewMock()
    var dataSource: MessagesDataSourceMock!
    var collab: Collab!
    
    override func setUp() {
        dataSource = MessagesDataSourceMock()
        collab = VyrlFaker.faker.collab()
        subject = MessagesInteractor(dataSource: dataSource, collab: collab)
    }
    
    func test_refreshData_reloadsDataSource() {
        subject.refreshData()
        
        XCTAssertTrue(dataSource.didUseLoadTableData)
    }
    
    func test_onViewWillAppear_loadsTableData() {
        subject.viewWillAppear()
        
        XCTAssertTrue(dataSource.didUseLoadTableData)
    }
    
    func test_use_forwardsUseToDataSource() {
        subject.use(tableView)
        
        XCTAssertTrue(dataSource.didUseTableView)
        XCTAssertTrue(dataSource.usedTableArgument === tableView)
    }
    
    func test_updateTable_reloadsTableViewInAllCases() {
        subject.use(tableView)
        let possibleResults = [DataFetchResult.someData, DataFetchResult.empty, DataFetchResult.error]
        
        for result in possibleResults {
            tableView.didCallReload = false
            subject.dataSource.tableViewControllingDelegate?.updateTable(with: result)
            XCTAssertTrue(tableView.didCallReload)
        }
    }
}
