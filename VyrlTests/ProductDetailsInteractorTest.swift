//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

// MARK: - Mocks


// MARK: - Tests

final class ProductDetailsInteractorTest: XCTestCase {
    
    var subject: ProductDetailsInteractor!
    var tableViewMock = TableViewMock()

    override func setUp() {
        subject = ProductDetailsInteractor()
    }
    
    func test_updateTable_reloadsTableViewInAllCases() {
        subject.use(tableViewMock)
        let possibleResults = [DataFetchResult.someData, DataFetchResult.empty, DataFetchResult.error]
        
        for result in possibleResults {
            tableViewMock.reloadDidCall = false
            subject.updateTable(with: result)
            XCTAssertTrue(tableViewMock.reloadDidCall)
        }
    }
}

// MARK: - End
