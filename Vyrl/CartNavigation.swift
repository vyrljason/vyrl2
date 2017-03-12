//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartNavigating: class {
    weak var cartNavigationController: UINavigationController? { get set }
    var cart: CartViewController! { get }
    func pushCheckout(with cartData: CartData)
}

protocol ShippingAddressViewPresenting: class {
    func showShippingAdressView()
}

protocol CheckoutSummaryViewPresenting: class {
    func presentSummaryView()
}

protocol ShippingAddressControlling: class {
    func finishPresentation(with shippingAddress: ShippingAddress?)
}

final class CartNavigationBuilder {

    var cartFactory: CartControllerMaking.Type = CartViewControllerFactory.self
    var checkoutFactory: CheckoutControllerMaking.Type = CheckoutControllerFactory.self

    func build() -> CartNavigation {
        let navigation = CartNavigation(cartFactory: cartFactory,
                                        checkoutFactory: checkoutFactory,
                                        shippingAddressFactory: ShippingAddressControllerFactory.self)
        return navigation
    }
}

final class CartNavigation: CartNavigating {

    var cart: CartViewController!
    fileprivate let checkoutFactory: CheckoutControllerMaking.Type
    fileprivate let shippingAddressFactory: ShippingAddressMaking.Type
    weak var cartNavigationController: UINavigationController?

    init(cartFactory: CartControllerMaking.Type,
         checkoutFactory: CheckoutControllerMaking.Type,
         shippingAddressFactory: ShippingAddressMaking.Type) {
        self.checkoutFactory = checkoutFactory
        self.shippingAddressFactory = shippingAddressFactory
        cart = cartFactory.make(cartNavigation: self)
    }

    func pushCheckout(with cartData: CartData) {
        let checkout = checkoutFactory.make(navigation: self, cartData: cartData)
        cartNavigationController?.pushViewController(checkout, animated: true)
    }
}

extension CartNavigation: ShippingAddressViewPresenting {
    func showShippingAdressView() {
        let viewController = shippingAddressFactory.make(using: self)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        cartNavigationController?.present(viewController, animated: true, completion: nil)
    }
}

extension CartNavigation: ShippingAddressControlling {
    func finishPresentation(with shippingAddress: ShippingAddress?) {
        cartNavigationController?.dismiss(animated: true, completion: nil)
    }
}

extension CartNavigation: CheckoutSummaryViewPresenting {
    func presentSummaryView() {
        //FIXME: present summary screen https://taiga.neoteric.eu/project/mpaprocki-vyrl-mobile/us/60
    }
}
