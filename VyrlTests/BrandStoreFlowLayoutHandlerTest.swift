//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

fileprivate final class FlowLayoutMock: UICollectionViewFlowLayout {
    var didInvalidate = false
    
    override func invalidateLayout() {
        didInvalidate = true
    }
}

final class BrandStoreFlowLayoutHandlerTest: XCTestCase {
    
    fileprivate var collectionViewMock: UICollectionView!
    fileprivate var flowLayoutMock: FlowLayoutMock!
    fileprivate var subject: BrandStoreFlowLayoutHandler!
    
    override func setUp() {
        super.setUp()
        flowLayoutMock = FlowLayoutMock()
        collectionViewMock = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayoutMock)
        subject = BrandStoreFlowLayoutHandler()
    }
    
    func test_fallbackHeaderHeight() {
        XCTAssertGreaterThan(subject.headerSize.height, 0)
    }
    
    func test_fallbackItemHeight() {
        XCTAssertGreaterThan(subject.itemSize.height, 0)
    }
    
    func test_updateHeight() {
        subject.headerDidChangeHeight(height: 999)
        XCTAssertEqual(subject.headerSize.height, 999)
    }
    
    func test_afterHeightChange_invalidatesFlowLayout() {
        subject.use(collectionViewMock)
        
        subject.headerDidChangeHeight(height: 999)
        
        XCTAssertTrue(flowLayoutMock.didInvalidate)
    }
}
