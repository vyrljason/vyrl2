//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CheckoutInteracting: class {
    weak var projector: CheckoutRendering? { get set }
    weak var navigation: ShippingAddressViewPresenting? { get set }
    func viewDidLoad()
    func didTapAddShippingAddress()
    func didUpdate(shippingAddress: ShippingAddress?)
}

final class CheckoutInteractor: CheckoutInteracting {

    fileprivate let cartItems: [CartItem]
    fileprivate let products: [Product]
    fileprivate var shippingAddress: ShippingAddress?

    weak var projector: CheckoutRendering?
    weak var navigation: ShippingAddressViewPresenting?

    init(cartData: CartData) {
        cartItems = cartData.cartItems
        products = cartData.products
    }

    func viewDidLoad() {
        refreshRenderable()
    }

    func didTapAddShippingAddress() {
        navigation?.showShippingAdressView()
    }

    func didUpdate(shippingAddress: ShippingAddress?) {
        self.shippingAddress = shippingAddress
        refreshRenderable()
    }

    private func refreshRenderable() {
        let renderable = CheckoutRenderable(products: products,
                                            address: shippingAddress,
                                            contact: "email@some.com\n(12) 123 4456") // TODO: Real contact
        projector?.render(renderable)
    }
}
