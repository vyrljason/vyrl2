//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SignUpInteracting {
    weak var presenter: ErrorAlertPresenting? { get set }
    func didPrepare(form: SignUpFormInteracting)
    func didTapSubmit()
}

final class SignUpInteractor: SignUpInteracting {

    private var form: SignUpFormInteracting?
    weak var presenter: ErrorAlertPresenting?

    weak var signUpNavigation: AuthorizationNavigating?

    func didPrepare(form: SignUpFormInteracting) {
        self.form = form
    }

    func didTapSubmit() {
        guard let form = form else { return }
        if case .invalid(let errorMessage) = form.status {
            presenter?.presentError(title: nil, message: errorMessage)
            return
        }
        guard let _ = form.result else { return }
        //TODO: call Service to execute networking call
    }
}
