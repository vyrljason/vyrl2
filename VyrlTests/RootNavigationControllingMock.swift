//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class RootNavigationControllingMock: RootNavigationControlling, CartPresenting, ChatPresenting {

    var showMenuCalled: Bool = false
    var showChatCalled: Bool = false
    var showCartCalled: Bool = false
    var dismissModalCalled: Bool = false

    func showMenu() {
        showMenuCalled = true
    }

    func showChat() {
        showChatCalled = true
    }

    func showCart() {
        showCartCalled = true
    }

    func dismissModal() {
        dismissModalCalled = true
    }
}
