//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol CheckoutSummaryInteracting {
    weak var navigation: CheckoutNavigationDismissing? { get set }
    func didTapGoToCollabs()
}

final class CheckoutSummaryInteractor: CheckoutSummaryInteracting {

    weak var navigation: CheckoutNavigationDismissing?

    func didTapGoToCollabs() {
        navigation?.dismiss(animated: true)
    }
}
