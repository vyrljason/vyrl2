//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ShippingAddressInteracting {
    weak var controller: ShippingAddressControlling? { get set }
    weak var presenter: ErrorAlertPresenting? { get set }
    func didPrepare(form: ShippingFormInteracting)
    func didTapCancel()
    func didTapAction()
}

final class ShippingAddressInteractor: ShippingAddressInteracting, FormActionDelegate {

    weak var controller: ShippingAddressControlling?
    private var form: ShippingFormInteracting?
    weak var presenter: ErrorAlertPresenting?

    func didPrepare(form: ShippingFormInteracting) {
        self.form = form
        form.delegate = self
    }

    func didTapCancel() {
        controller?.finishPresentation(with: nil)
    }

    func didTapAction() {
        guard let form = form else { return }
        if case .invalid(let errorMessage) = form.status {
            presenter?.presentError(title: nil, message: errorMessage)
            return
        }
        guard let shippingAddress = form.result else { return }
        controller?.finishPresentation(with: shippingAddress)
    }
}
