//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import DZNEmptyDataSet

final class EmptyCollectionViewHandlerTest: XCTestCase {

    var collectionView: CollectionViewMock!
    var subject: EmptyCollectionViewHandler!

    override func setUp() {
        super.setUp()
        collectionView = CollectionViewMock()
        subject = EmptyCollectionViewHandler()
    }

    func test_use_setsEmptyDataSetDelegateAndSource() {
        subject.use(collectionView)

        XCTAssertNotNil(collectionView.emptyDataSetSource)
        XCTAssertNotNil(collectionView.emptyDataSetDelegate)
    }

    func test_use_whenNotConfigured_wontDisplayEmptyDataSet() {
        subject.use(collectionView)

        XCTAssertFalse(subject.emptyDataSetShouldDisplay(collectionView))
    }

    func test_configure_enablesToDisplayEmptyDataSet() {
        subject.use(collectionView)

        subject.configure(with: .noData)

        XCTAssertTrue(subject.emptyDataSetShouldDisplay(collectionView))
    }

    func test_configure_setsTitleUsingMode() {
        let mode: EmptyCollectionMode = .noData
        subject.use(collectionView)

        subject.configure(with: mode)

        XCTAssertEqual(subject.title(forEmptyDataSet: collectionView), mode.title)
    }

    func test_configure_setsDescriptionUsingMode() {
        let mode: EmptyCollectionMode = .noData
        subject.use(collectionView)

        subject.configure(with: .noData)

        XCTAssertEqual(subject.description(forEmptyDataSet: collectionView), mode.description)
    }
}
