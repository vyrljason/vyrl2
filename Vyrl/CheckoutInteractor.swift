//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let incompleteDataError =  NSLocalizedString("checkout.error.incompleteData", comment: "")
    static let checkoutError =  NSLocalizedString("checkout.error.api", comment: "")
}

protocol ShippingAddressUpdateListening: class {
    func didUpdate(shippingAddress: ShippingAddress?)
}

protocol CheckoutInteracting: class, ShippingAddressUpdateListening {
    weak var projector: CheckoutRendering? { get set }
    weak var navigation: ShippingAddressViewPresenting & CheckoutSummaryViewPresenting? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    func viewDidLoad()
    func didTapAddShippingAddress()
    func didTapCheckout()
}

final class CheckoutInteractor: CheckoutInteracting {

    fileprivate let cartItems: [CartItem]
    fileprivate let products: [Product]
    fileprivate var shippingAddress: ShippingAddress?
    fileprivate let contactInfo = VyrlFaker.faker.contactInfo() //FIXME: https://taiga.neoteric.eu/project/mpaprocki-vyrl-mobile/us/112
    fileprivate let service: OrderProposalSending
    fileprivate let cartStorage: CartStoring

    weak var projector: CheckoutRendering?
    weak var navigation: ShippingAddressViewPresenting & CheckoutSummaryViewPresenting?
    weak var errorPresenter: ErrorAlertPresenting?

    init(cartData: CartData, service: OrderProposalSending, cartStorage: CartStoring) {
        cartItems = cartData.cartItems
        products = cartData.products
        self.service = service
        self.cartStorage = cartStorage
    }

    func viewDidLoad() {
        refreshRenderable()
    }

    func didTapAddShippingAddress() {
        navigation?.showShippingAdressView(using: self)
    }

    func didUpdate(shippingAddress: ShippingAddress?) {
        self.shippingAddress = shippingAddress
        refreshRenderable()
    }

    private func refreshRenderable() {
        let renderable = CheckoutRenderable(products: products,
                                            address: shippingAddress,
                                            contact: contactInfo)
        projector?.render(renderable)
    }

    func didTapCheckout() {
        guard let shippingAddress = shippingAddress else {
            errorPresenter?.presentError(title: nil, message: Constants.incompleteDataError)
            return
        }
        let orderProposal = OrderProposal(products: cartItems, shippingAddress: shippingAddress, contactInfo: contactInfo)
        service.send(proposal: orderProposal) { [weak self] result in
            guard let `self` = self else { return }
            result.on(success: { _ in
                self.cartStorage.clear()
                self.navigation?.presentSummaryView()
            }, failure: { _ in
                self.errorPresenter?.presentError(title: nil, message: Constants.checkoutError)
            })
        }
    }
}
