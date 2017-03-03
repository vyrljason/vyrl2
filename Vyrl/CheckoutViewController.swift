//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct CheckoutRenderable {
    let summaryHead: String
    let summarySubHead: String
    let address: String?
    let addressButtonVisible: Bool
    let contact: String?
    let agreement: NSAttributedString
    let checkoutButtonVisible: Bool
}

extension CheckoutRenderable {

    private enum Constants {
        static let summaryHeadFormat = NSLocalizedString("checkout.summaryHeadFormat", comment: "") as NSString
        static let summarySubHeadFormat = NSLocalizedString("checkout.summarySubHeadFormat", comment: "") as NSString
        static let agreement = NSAttributedString(string: VyrlFaker.faker.lorem.paragraph(sentencesAmount: 10),
                                                  attributes: StyleKit.infoViewAttributes)
    }

    init(products: [Product], address: String?, contact: String?) {
        let summary = CartSummary(products: products)
        summaryHead = NSString(format: Constants.summaryHeadFormat, summary.productsCount, summary.brandsCount) as String
        summarySubHead = NSString(format: Constants.summarySubHeadFormat, summary.brandsCount) as String
        self.address = address
        self.addressButtonVisible = address == nil
        self.contact = contact
        self.agreement = Constants.agreement
        self.checkoutButtonVisible = !self.addressButtonVisible
    }
}

protocol CheckoutRendering: class {
    func render(_ renderable: CheckoutRenderable)
}

final class CheckoutViewController: UIViewController, HavingNib {

    @IBOutlet fileprivate var summaryHead: UILabel!
    @IBOutlet fileprivate var summarySubHead: UILabel!
    @IBOutlet fileprivate var address: UILabel!
    @IBOutlet fileprivate var contact: UILabel!
    @IBOutlet fileprivate var addressTextContainer: UIView!
    @IBOutlet fileprivate var contactTextContainer: UIView!
    @IBOutlet fileprivate var addressButtonContainer: UIView!
    @IBOutlet fileprivate var contactButtonContainer: UIView!
    @IBOutlet fileprivate var agreement: AutoexpandableTextView!
    @IBOutlet fileprivate var scroll: UIScrollView!

    private enum Constants {
        static let title = NSLocalizedString("checkout.title", comment: "")
        static let scrollViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
    }

    private let interactor: CheckoutInteracting

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
        address.text = renderable.address
        addressButtonContainer.isHidden = !renderable.addressButtonVisible
        addressTextContainer.isHidden = renderable.addressButtonVisible
        contact.text = renderable.contact
        agreement.attributedText = renderable.agreement
    }
}
