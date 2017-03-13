//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ContactInfoInteracting {
    weak var listener: ContactInfoUpdateListening? { get set }
    weak var controller: ContactInfoControlling? { get set }
    weak var presenter: ErrorAlertPresenting? { get set }
    func didPrepare(form: ContactInfoFormInteracting)
    func didTapCancel()
    func didTapAction()
}

final class ContactInfoInteractor: ContactInfoInteracting, FormActionDelegate {

    weak var listener: ContactInfoUpdateListening?
    weak var controller: ContactInfoControlling?
    private var form: ContactInfoFormInteracting?
    weak var presenter: ErrorAlertPresenting?

    func didPrepare(form: ContactInfoFormInteracting) {
        self.form = form
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
        guard let contactInfo = form.result else { return }
        listener?.didUpdate(contactInfo: contactInfo)
        controller?.finishPresentation(with: contactInfo)
    }
}
