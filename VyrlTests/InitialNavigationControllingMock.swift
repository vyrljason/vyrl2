//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class InitialNavigationControllingMock: InitialNavigationControlling {

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
