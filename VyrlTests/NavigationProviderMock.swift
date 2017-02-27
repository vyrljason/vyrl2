//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class NavigationProviderMock: NavigationControlling {

    let navigationController: UINavigationController

    var didResetNavigation = false
    var didDismissModal = false

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func dismiss(animated: Bool) {
        didDismissModal = true
    }

    func goToFirst(animated: Bool) {
        didResetNavigation = true
    }
}
