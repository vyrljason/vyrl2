//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CheckoutInteracting: class {
    weak var projector: CheckoutRendering? { get set }
    func viewDidLoad()
}

final class CheckoutInteractor: CheckoutInteracting {

    fileprivate let cartItems: [CartItem]
    fileprivate let products: [Product]

    weak var projector: CheckoutRendering?

    init(cartData: CartData) {
        cartItems = cartData.cartItems
        products = cartData.products
    }

    func viewDidLoad() {
        let renderable = CheckoutRenderable(products: products,
                                            address: "John Mayer\n583 Jefferson Street, Tiburon, CA 94920", // TODO: Real address
                                            contact: "email@some.com\n(12) 123 4456") // TODO: Real contact
        projector?.render(renderable)
    }
}
