//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

@objc protocol RootNavigationInteracting: class {
    func didTapChat()
    func didTapCart()
    func didTapMenu()
    func didTapClose()
}

protocol NavigationDelegateHaving: class {
    weak var delegate: (RootNavigationControlling & CartPresenting & ChatPresenting)? { get set }
}

final class RootNavigationInteractor: RootNavigationInteracting, NavigationDelegateHaving {

    weak var delegate: (RootNavigationControlling & CartPresenting & ChatPresenting)?

    @objc func didTapChat() {
        delegate?.showChat()
    }

    @objc func didTapCart() {
        delegate?.showCart()
    }

    @objc func didTapMenu() {
        delegate?.showMenu()
    }

    @objc func didTapClose() {
        delegate?.dismissModal()
    }
}
