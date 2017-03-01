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
    private var credentialsProvider: APICredentialsProviderMock!

    override func setUp() {
        super.setUp()
        homeScreenPresentingMock = HomeScreenPresentingMock()
        dataSource = DataSourceMock()
        credentialsProvider = APICredentialsProviderMock()
        subject = LeftMenuInteractor(dataSource: dataSource, credentialsProvider: credentialsProvider)
        subject.delegate = homeScreenPresentingMock
    }

    func test_didTapHome_calledShowHome() {
        subject.didTapHome()

        XCTAssertTrue(homeScreenPresentingMock.showHomeCalled)
    }

    func test_showCategory_calledShowCategory() {
        let category = Vyrl.Category(id: "0", name: "X")
        subject.didSelect(category: category)

        XCTAssertEqual(homeScreenPresentingMock.category?.id, category.id)
    }

    func test_didTapAccount_calledShowHome() {
        subject.didTapAccount()

        XCTAssertTrue(homeScreenPresentingMock.showAccountCalled)
    }

    func test_use_usingCollectionView() {
        let collectionView = CollectionViewMock()

        subject.use(collectionView)

        XCTAssertTrue(dataSource.collectionView === collectionView)
    }

    func test_didTapLogout_calledShowAuthorizationAndCallsClear() {
        subject.didTapLogout()

        XCTAssertTrue(homeScreenPresentingMock.showAuthorizationCalled)
        XCTAssertTrue(credentialsProvider.didCallClear)

    }
}
