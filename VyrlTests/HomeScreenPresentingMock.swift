//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl

final class HomeScreenPresentingMock: HomeScreenPresenting, CategoryPresenting, AccountScreenPresenting {

    var showHomeCalled = false
    var showAccountCalled = false
    var category: Vyrl.Category?

    func showHome() {
        showHomeCalled = true
    }

    func show(_ category: Vyrl.Category) {
        self.category = category
    }

    func showAccount() {
        showAccountCalled = true
    }
}
