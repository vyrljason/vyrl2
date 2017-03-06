//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ConfirmationInteracting {
    func didTapDismiss()
}

final class ConfirmationInteractor: ConfirmationInteracting {
    func didTapDismiss() {
        
    }
}

struct ConfirmationRenderable {
    let title: String
    let subtitle: String
}

final class ConfirmationViewController: UIViewController, HavingNib {

    static var nibName: String = "ConfirmationViewController"

    let interactor: ConfirmationInteracting

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    init(interactor: ConfirmationInteracting) {
        self.interactor = interactor
        super.init(nibName: CheckoutViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func didTapDismiss() {
        interactor.didTapDismiss()
    }

    func render(_ renderable: ConfirmationRenderable) {
        titleLabel.text = renderable.title
        subtitleLabel.text = renderable.subtitle
    }
}
