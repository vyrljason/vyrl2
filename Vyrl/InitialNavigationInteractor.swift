//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

@objc protocol InitialNavigationInteracting: class {
    func didTapChat()
    func didTapCart()
    func didTapMenu()
    func didTapClose()
}

protocol NavigationDelegateHaving: class {
    weak var delegate: InitialNavigationControlling? { get set }
}

final class InitialNavigationInteractor: InitialNavigationInteracting, NavigationDelegateHaving {

    weak var delegate: InitialNavigationControlling?

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
