//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct CheckoutRenderable {
    let summaryHead: String
    let summarySubHead: String
    let address: String?
    let addressButtonVisible: Bool
    let contact: String?
    let contactButtonVisible: Bool
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

    init(products: [Product], address: ShippingAddress?, contact: ContactInfo?) {
        let summary = CartSummary(products: products)
        summaryHead = NSString(format: Constants.summaryHeadFormat, summary.productsCount, summary.brandsCount) as String
        summarySubHead = NSString(format: Constants.summarySubHeadFormat, summary.brandsCount) as String
        self.address = address?.description
        self.addressButtonVisible = address == nil
        self.contact = contact?.description
        self.contactButtonVisible = contact == nil
        self.agreement = Constants.agreement
        self.checkoutButtonVisible = !self.addressButtonVisible
    }
}
