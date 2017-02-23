//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl

final class HomeScreenPresentingMock: HomeScreenPresenting, CategoryPresenting {

    var showHomeCalled = false
    var category: Vyrl.Category?

    func showHome() {
        showHomeCalled = true
    }

    func show(_ category: Vyrl.Category) {
        self.category = category
    }
}
