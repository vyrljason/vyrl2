//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let incompleteDataError =  NSLocalizedString("checkout.error.incompleteData", comment: "")
}

protocol ShippingAddressUpdateListening: class {
    func didUpdate(shippingAddress: ShippingAddress?)
}

protocol ContactInfoUpdateListening: class {
    func didUpdate(contactInfo: ContactInfo?)
}

protocol CheckoutInteracting: class, ShippingAddressUpdateListening, ContactInfoUpdateListening {
    weak var projector: (CheckoutRendering & ActionButtonRendering)? { get set }
    weak var navigation: (ShippingAddressViewPresenting & ContactInfoViewPresenting & CheckoutSummaryViewPresenting)? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    func viewDidLoad()
    func didTapAddShippingAddress()
    func didTapContactInfo()
    func didTapCheckout()
}

final class CheckoutInteractor: CheckoutInteracting {

    fileprivate let cartItems: [CartItem]
    fileprivate let products: [Product]
    fileprivate var shippingAddress: ShippingAddress?
    fileprivate var contactInfo: ContactInfo?
    fileprivate let service: OrderProposalSending
    fileprivate let cartStorage: CartStoring

    weak var projector: (CheckoutRendering & ActionButtonRendering)?
    weak var navigation: (ShippingAddressViewPresenting & ContactInfoViewPresenting & CheckoutSummaryViewPresenting)?
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

    func didTapContactInfo() {
        navigation?.showContactInfoView(using: self)
    }

    func didUpdate(shippingAddress: ShippingAddress?) {
        self.shippingAddress = shippingAddress
        refreshRenderable()
    }

    func didUpdate(contactInfo: ContactInfo?) {
        self.contactInfo = contactInfo
        refreshRenderable()
    }

    private func refreshActionRenderable() {
        let state: ActionButtonState
        if let _ = contactInfo, let _ = shippingAddress {
            state = .enabled
        } else {
            state = .disabled
        }
        projector?.render(ActionButtonRenderable(state: state))
    }
    private func refreshRenderable() {
        let renderable = CheckoutRenderable(products: products,
                                            address: shippingAddress,
                                            contact: contactInfo)
        projector?.render(renderable)
        refreshActionRenderable()
    }

    func didTapCheckout() {
        guard let shippingAddress = shippingAddress, let contactInfo = contactInfo else {
            errorPresenter?.presentError(title: nil, message: Constants.incompleteDataError)
            return
        }
        projector?.render(ActionButtonRenderable(state: .inProgress))
        let orderProposal = OrderProposal(products: cartItems, shippingAddress: shippingAddress, contactInfo: contactInfo)
        service.send(proposal: orderProposal) { [weak self] result in
            guard let `self` = self else { return }
            self.refreshActionRenderable()
            result.on(success: { _ in
                self.cartStorage.clear()
                self.navigation?.presentSummaryView()
            }, failure: { error in
                self.errorPresenter?.presentError(title: error.title, message: error.message)
            })
        }
    }
}
