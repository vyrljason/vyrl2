//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CheckoutSummaryControllerMaking {
    static func make(navigation: CheckoutNavigationDismissing) -> CheckoutSummaryViewController
}

final class CheckoutSummaryControllerFactory: CheckoutSummaryControllerMaking {
    static func make(navigation: CheckoutNavigationDismissing) -> CheckoutSummaryViewController {
        let interactor = CheckoutSummaryInteractor()
        let viewController = CheckoutSummaryViewController(interactor: interactor)
        interactor.navigation = navigation
        return viewController
    }
}
