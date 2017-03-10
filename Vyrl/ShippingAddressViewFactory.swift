//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ShippingAddressMaking {
    static func make(using controller: ShippingAddressControlling) -> ShippingAddressViewController
}

enum ShippingAddressControllerFactory: ShippingAddressMaking {
    static func make(using controller: ShippingAddressControlling) -> ShippingAddressViewController {
        let shippingInteractor = ShippingAddressInteractor()
        let shippingAddressViewController = ShippingAddressViewController(interactor: shippingInteractor, formFactory: ShippingAddressFormFactory.self)
        shippingInteractor.controller = controller
        shippingInteractor.presenter = shippingAddressViewController
        return shippingAddressViewController
    }
}
