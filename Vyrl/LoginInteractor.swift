//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol LoginInteracting: class, FormActionDelegate {
    weak var presenter: ErrorAlertPresenting & ViewActivityPresenting? { get set }
    func didPrepare(form: LoginFormInteracting)
}

protocol AuthorizationListener: class {
    func didFinishAuthorizing()
}

final class LoginInteractor: LoginInteracting {

    fileprivate var form: LoginFormInteracting?
    fileprivate let service: UserLoginProviding
    fileprivate let credentialsStorage: CredentialsStoring
    weak var presenter: ErrorAlertPresenting & ViewActivityPresenting?
    weak var listener: AuthorizationListener?

    init(service: UserLoginProviding, credentialsStorage: CredentialsStoring) {
        self.service = service
        self.credentialsStorage = credentialsStorage
    }

    func didPrepare(form: LoginFormInteracting) {
        self.form = form
        self.form?.delegate = self
    }
}

extension LoginInteractor: FormActionDelegate {

    func didTapAction() {
        guard let form = form else { return }
        guard let credentials = form.result else { return }
        if case .invalid(let errorMessage) = form.status {
            presenter?.presentError(title: nil, message: errorMessage)
            return
        }
        presenter?.presentActivity()
        service.login(using: credentials) { [weak self] result in
            guard let `self` = self else { return }
            self.presenter?.dismiss()
            result.on(success: { userProfile in
                self.credentialsStorage.saveToken(using: userProfile)
                self.listener?.didFinishAuthorizing()
            }, failure: { error in
                self.presenter?.presentError(title: error.title, message: error.message)
            })
        }
    }
}
