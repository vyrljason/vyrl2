//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CheckoutControllerMaking {
    static func make(navigation: ShippingAddressViewPresenting & CheckoutSummaryViewPresenting, cartData: CartData) -> CheckoutViewController
}

final class CheckoutControllerFactory: CheckoutControllerMaking {
    static func make(navigation: ShippingAddressViewPresenting & CheckoutSummaryViewPresenting, cartData: CartData) -> CheckoutViewController {

        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = PostService<OrderProposalResource>(resource: OrderProposalResource(controller: resourceController))
        let service = OrderProposalService(resource: resource)
        let interactor = CheckoutInteractor(cartData: cartData, service: service)
        let viewController = CheckoutViewController(interactor: interactor)
        interactor.errorPresenter = viewController
        interactor.projector = viewController
        interactor.navigation = navigation
        return viewController
    }
}
