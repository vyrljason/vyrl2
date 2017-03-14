//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CheckoutRendering: class {
    func render(_ renderable: CheckoutRenderable)
}

protocol ActionButtonRendering: class {
    func render(_ renderable: ActionButtonRenderable)
}

private enum Constants {
    static let title = NSLocalizedString("checkout.title", comment: "")
    static let scrollViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
    static let enabledColor = UIColor.rouge
    static let disabledColor = UIColor.greyishBrown
}

final class CheckoutViewController: UIViewController, HavingNib {

    @IBOutlet fileprivate weak var summaryHead: UILabel!
    @IBOutlet fileprivate weak var summarySubHead: UILabel!
    @IBOutlet fileprivate var addressContainer: ActionDescriptionView!
    @IBOutlet fileprivate var contactContainer: ActionDescriptionView!
    @IBOutlet fileprivate weak var agreement: AutoexpandableTextView!
    @IBOutlet fileprivate weak var scroll: UIScrollView!
    @IBOutlet fileprivate weak var checkoutButton: UIButton!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!

    fileprivate let interactor: CheckoutInteracting

    static var nibName: String = "CheckoutViewController"

    init(interactor: CheckoutInteracting) {
        self.interactor = interactor
        super.init(nibName: CheckoutViewController.nibName, bundle: nil)
        title = Constants.title
        interactor.projector = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        interactor.viewDidLoad()
        scroll.contentInset = Constants.scrollViewInset
    }
}

extension CheckoutViewController: CheckoutRendering {
    func render(_ renderable: CheckoutRenderable) {
        summaryHead.text = renderable.summaryHead
        summarySubHead.text = renderable.summarySubHead
        addressContainer.render(renderable.shippingAddress)
        contactContainer.render(renderable.contact)
        agreement.attributedText = renderable.agreement
    }
}

extension CheckoutViewController: ActionButtonRendering {
    func render(_ renderable: ActionButtonRenderable) {
        checkoutButton.backgroundColor = renderable.isEnabled ? Constants.enabledColor : Constants.disabledColor
        checkoutButton.isEnabled = renderable.isEnabled
        if renderable.isActivityIndicatorVisible {
            checkoutButton.setTitle(nil, for: .normal)
            activityIndicator.startAnimating()
        } else {
            checkoutButton.setTitle(Constants.title, for: .normal)
            activityIndicator.stopAnimating()
        }
    }
}

extension CheckoutViewController {
    @IBAction private func didTapAddShippingAddress() {
        interactor.didTapAddShippingAddress()
    }

    @IBAction private func didTapContactInfo() {
        interactor.didTapContactInfo()
    }

    @IBAction private func didTapCheckout() {
        interactor.didTapCheckout()
    }
}
