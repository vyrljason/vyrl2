//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl

final class HomeScreenPresentingMock: HomeScreenPresenting {

    var showHomeCalled = false

    func showHome() {
        showHomeCalled = true
    }
}
