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

protocol ShippingAddressControlling: class {
    func finishPresentation(with shippingAddress: ShippingAddress?)
}

final class CartNavigationBuilder {

    var factory: CartViewControllerFactory.Type = CartViewControllerFactory.self

    func build() -> CartNavigation {
        let navigation = CartNavigation(cartFactory: factory,
                                        shippingAddressFactory: ShippingAddressControllerFactory.self)
        return navigation
    }
}

final class CartNavigation: CartNavigating {

    var cart: CartViewController!
    fileprivate var shippingAddressFactory: ShippingAddressMaking.Type
    fileprivate weak var interactor: CheckoutInteracting?
    
    init(cartFactory: CartViewControllerFactory.Type,
         shippingAddressFactory: ShippingAddressMaking.Type) {
        self.shippingAddressFactory = shippingAddressFactory
        cart = cartFactory.make(cartNavigation: self)
    }

    weak var cartNavigationController: UINavigationController?

    func pushCheckout(with cartData: CartData) {
        let interactor = CheckoutInteractor(cartData: cartData)
        interactor.navigation = self
        self.interactor = interactor
        let checkout = CheckoutViewController(interactor: interactor)
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
        interactor?.didUpdate(shippingAddress: shippingAddress)
    }
}
