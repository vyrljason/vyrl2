//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ShippingAddressViewMaking {
    static func make(controller: ShippingAddressControlling, listener: ShippingAddressUpdateListening) -> ShippingAddressViewController
}

enum ShippingAddressControllerFactory: ShippingAddressViewMaking {
    static func make(controller: ShippingAddressControlling, listener: ShippingAddressUpdateListening) -> ShippingAddressViewController {
        let shippingInteractor = ShippingAddressInteractor()
        let shippingAddressViewController = ShippingAddressViewController(interactor: shippingInteractor, formFactory: ShippingAddressFormFactory.self)
        shippingInteractor.controller = controller
        shippingInteractor.presenter = shippingAddressViewController
        shippingInteractor.listener = listener
        return shippingAddressViewController
    }
}
