//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Fakery

// MARK - Mocks

// MARK - Tests

final class ProductDetailsDataSourceTest: XCTestCase {
    
    var product = VyrlFaker.faker.product()
    var tableViewMock: TableViewMock!
    var subject: ProductDetailsDataSource!
    
    override func setUp() {
        tableViewMock = TableViewMock()
        subject = ProductDetailsDataSource(product: product)
    }
    
    func test_use_registersNibs() {
        subject.use(tableViewMock)
        
        XCTAssertTrue(tableViewMock.didRegisterNib)
    }
    
    func test_use_setsDelegateAndDataSource_onTableView() {
        subject.use(tableViewMock)
        
        XCTAssertTrue(tableViewMock.didSetDataSource)
        XCTAssertTrue(tableViewMock.dataSource === subject)
        XCTAssertTrue(tableViewMock.didSetDelegation)
        XCTAssertTrue(tableViewMock.delegate === subject)
    }
}

// MARK - End
