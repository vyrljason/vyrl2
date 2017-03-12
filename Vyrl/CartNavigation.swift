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
    func showShippingAdressView(using listener: ShippingAddressUpdateListening)
}

protocol CheckoutSummaryViewPresenting: class {
    func presentSummaryView()
}

protocol CheckoutNavigationDismissing: class {
    func dismiss(animated: Bool)
}

protocol ShippingAddressControlling: class {
    func finishPresentation(with shippingAddress: ShippingAddress?)
}

final class CartNavigationBuilder {

    var cartFactory: CartControllerMaking.Type = CartViewControllerFactory.self
    var checkoutFactory: CheckoutControllerMaking.Type = CheckoutControllerFactory.self
    var summaryFactory: CheckoutSummaryControllerMaking.Type = CheckoutSummaryControllerFactory.self
    var shippingAddressFactory: ShippingAddressMaking.Type = ShippingAddressControllerFactory.self

    func build() -> CartNavigation {
        let navigation = CartNavigation(cartFactory: cartFactory,
                                        checkoutFactory: checkoutFactory,
                                        summaryFactory: summaryFactory,
                                        shippingAddressFactory: shippingAddressFactory)
        return navigation
    }
}

final class CartNavigation: CartNavigating {

    var cart: CartViewController!
    fileprivate let checkoutFactory: CheckoutControllerMaking.Type
    fileprivate let shippingAddressFactory: ShippingAddressMaking.Type
    fileprivate let summaryFactory: CheckoutSummaryControllerMaking.Type
    weak var cartNavigationController: UINavigationController?

    init(cartFactory: CartControllerMaking.Type,
         checkoutFactory: CheckoutControllerMaking.Type,
         summaryFactory: CheckoutSummaryControllerMaking.Type,
         shippingAddressFactory: ShippingAddressMaking.Type) {
        self.checkoutFactory = checkoutFactory
        self.shippingAddressFactory = shippingAddressFactory
        self.summaryFactory = summaryFactory
        cart = cartFactory.make(cartNavigation: self)
    }

    func pushCheckout(with cartData: CartData) {
        let checkout = checkoutFactory.make(navigation: self, cartData: cartData)
        cartNavigationController?.pushViewController(checkout, animated: true)
    }
}

extension CartNavigation: ShippingAddressViewPresenting {
    func showShippingAdressView(using listener: ShippingAddressUpdateListening) {
        let viewController = shippingAddressFactory.make(controller: self, listener: listener)
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
        let summary = summaryFactory.make(navigation: self)
        cartNavigationController?.pushViewController(summary, animated: true)
    }
}
extension CartNavigation: CheckoutNavigationDismissing {
    func dismiss(animated: Bool) {
        cartNavigationController?.dismiss(animated: animated, completion: nil)
    }
}
