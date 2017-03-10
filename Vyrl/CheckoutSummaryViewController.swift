//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CheckoutSummaryViewController: UIViewController, HavingNib {

    private enum Constants {
        static let title = NSLocalizedString("checkout.title", comment: "")
    }

    fileprivate let interactor: CheckoutSummaryInteracting

    static var nibName: String = "CheckoutSummaryViewController"

    init(interactor: CheckoutSummaryInteracting) {
        self.interactor = interactor
        super.init(nibName: CheckoutSummaryViewController.nibName, bundle: nil)
        title = Constants.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckoutSummaryViewController {

    @IBAction private func didTapGoToCollabs() {
        interactor.didTapGoToCollabs()
    }
}
