//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CollabsInteractorNoDataMock: CollabsInteracting {
    
    private var emptyTableHandler: EmptyTableViewHandler = CollabsViewControllerFactory.makeEmptyTableHandler()
    
    func viewWillAppear() { }
    
    func use(_ tableView: UITableView) {
        emptyTableHandler.use(tableView)
        emptyTableHandler.configure(with: .noData)
        tableView.reloadEmptyDataSet()
    }
}

final class CollabsControllerSnapshotTest: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testCollabsWithNoData() {
        let interactor = CollabsInteractorNoDataMock()
        let subject = CollabsViewController(interactor: interactor)
        
        verifyForScreens(view: subject.view)
    }
}
