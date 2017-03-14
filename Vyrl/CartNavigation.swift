//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartNavigating: class {
    weak var cartNavigationController: UINavigationController? { get set }
    weak var chatPresenter: ChatPresenting? { get set }
    var cart: CartViewController! { get }
    func pushCheckout(with cartData: CartData)
}

protocol CheckoutSummaryViewPresenting: class {
    func presentSummaryView()
}

protocol CheckoutNavigationDismissing: class {
    func dismiss(animated: Bool)
}

protocol ShippingAddressViewPresenting: class {
    func showShippingAdressView(using listener: ShippingAddressUpdateListening)
}

protocol ShippingAddressControlling: class {
    func finishPresentation(with shippingAddress: ShippingAddress?)
}

protocol ContactInfoViewPresenting: class {
    func showContactInfoView(using listener: ContactInfoUpdateListening)
}

protocol ContactInfoControlling: class {
    func finishPresentation(with contactInfo: ContactInfo?)
}

final class CartNavigationBuilder {

    var cartFactory: CartControllerMaking.Type = CartViewControllerFactory.self
    var checkoutFactory: CheckoutControllerMaking.Type = CheckoutControllerFactory.self
    var summaryFactory: CheckoutSummaryControllerMaking.Type = CheckoutSummaryControllerFactory.self
    var shippingAddressFactory: ShippingAddressViewMaking.Type = ShippingAddressControllerFactory.self
    var contactInfoFactory: ContactInfoViewMaking.Type = ContactInfoViewFactory.self

    func build() -> CartNavigation {
        let navigation = CartNavigation(cartFactory: cartFactory,
                                        checkoutFactory: checkoutFactory,
                                        summaryFactory: summaryFactory,
                                        shippingAddressFactory: shippingAddressFactory,
                                        contactInfoFactory: contactInfoFactory)
        return navigation
    }
}

final class CartNavigation: CartNavigating {
    
    var cart: CartViewController!
    fileprivate let checkoutFactory: CheckoutControllerMaking.Type
    fileprivate let shippingAddressFactory: ShippingAddressViewMaking.Type
    fileprivate let summaryFactory: CheckoutSummaryControllerMaking.Type
    fileprivate let contactInfoFactory: ContactInfoViewMaking.Type

    weak var cartNavigationController: UINavigationController?
    weak var chatPresenter: ChatPresenting?

    init(cartFactory: CartControllerMaking.Type,
         checkoutFactory: CheckoutControllerMaking.Type,
         summaryFactory: CheckoutSummaryControllerMaking.Type,
         shippingAddressFactory: ShippingAddressViewMaking.Type,
         contactInfoFactory: ContactInfoViewMaking.Type) {
        self.checkoutFactory = checkoutFactory
        self.shippingAddressFactory = shippingAddressFactory
        self.summaryFactory = summaryFactory
        self.contactInfoFactory = contactInfoFactory
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

extension CartNavigation: ContactInfoViewPresenting {
    func showContactInfoView(using listener: ContactInfoUpdateListening) {
        let viewController = contactInfoFactory.make(controller: self, listener: listener)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        cartNavigationController?.present(viewController, animated: true, completion: nil)
    }
}

extension CartNavigation: ContactInfoControlling {
    func finishPresentation(with contactInfo: ContactInfo?) {
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

extension CartNavigation: ChatPresenting {
    func showChat() {
        chatPresenter?.showChat()
    }
}
