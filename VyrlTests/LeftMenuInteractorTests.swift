//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import SlideMenuControllerSwift
@testable import Vyrl

final class LeftMenuInteractorTests: XCTestCase {

    private var homeScreenPresentingMock: HomeScreenPresentingMock!
    private var dataSource: DataSourceMock!
    private var subject: LeftMenuInteractor!

    override func setUp() {
        super.setUp()
        homeScreenPresentingMock = HomeScreenPresentingMock()
        dataSource = DataSourceMock()
        subject = LeftMenuInteractor(dataSource: dataSource)
        subject.delegate = homeScreenPresentingMock
    }

    func test_showHome_calledShowHome() {
        subject.didTapHome()

        XCTAssertTrue(homeScreenPresentingMock.showHomeCalled)
    }

    func test_showCategory_calledShowCategory() {
        let category = Vyrl.Category(id: "0", name: "X")
        subject.didSelect(category: category)

        XCTAssertEqual(homeScreenPresentingMock.category?.id, category.id)
    }

    func test_use_usingCollectionView() {
        let collectionView = CollectionViewMock()

        subject.use(collectionView)

        XCTAssertTrue(dataSource.collectionView === collectionView)
    }
}
