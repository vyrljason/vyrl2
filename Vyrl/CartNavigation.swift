//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartNavigating: class {
    weak var cartNavigationController: UINavigationController? { get set }
    var cart: CartViewController! { get }
    func pushCheckout(with cartData: CartData)
}

final class CartNavigationBuilder {

    var factory: CartViewControllerFactory.Type = CartViewControllerFactory.self

    func build() -> CartNavigation {
        let navigation = CartNavigation(factory: factory)
        return navigation
    }
}

final class CartNavigation: CartNavigating {

    var cart: CartViewController!

    init(factory: CartViewControllerFactory.Type) {
        cart = factory.make(cartNavigation: self)
    }

    weak var cartNavigationController: UINavigationController?

    func pushCheckout(with cartData: CartData) {
        let interactor = CheckoutInteractor(cartData: cartData)
        let checkout = CheckoutViewController(interactor: interactor)
        cartNavigationController?.pushViewController(checkout, animated: true)
    }
}
