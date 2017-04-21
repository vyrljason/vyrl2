//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol LoginInteracting: class, FormActionDelegate {
    weak var navigator: AuthorizationNavigating? { get set }
    weak var presenter: (ErrorAlertPresenting & ViewActivityPresenting)? { get set }
    func didPrepare(form: LoginFormInteracting)
}

protocol AuthorizationListener: class {
    func didFinishAuthorizing()
}

final class LoginInteractor: LoginInteracting {

    fileprivate var form: LoginFormInteracting?
    fileprivate let apiLoginService: UserLoginProviding
    fileprivate let chatLoginService: ChatAuthenticating
    fileprivate let credentialsStorage: CredentialsStoring
    weak var navigator: AuthorizationNavigating?
    weak var presenter: (ErrorAlertPresenting & ViewActivityPresenting)?
    weak var listener: AuthorizationListener?

    init(apiLoginService: UserLoginProviding,
         chatLoginService: ChatAuthenticating,
         credentialsStorage: CredentialsStoring,
         navigator: AuthorizationNavigating) {
        self.apiLoginService = apiLoginService
        self.chatLoginService = chatLoginService
        self.credentialsStorage = credentialsStorage
        self.navigator = navigator
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
        apiLoginService.login(using: credentials) { [weak self] apiResult in
            guard let `self` = self else { return }
            apiResult.on(success: { userToken in
                self.credentialsStorage.saveToken(using: userToken)
                self.chatLoginService.authenticateUser { chatResult in
                    chatResult.on(success: { _ in
                        self.presenter?.dismiss()
                        self.listener?.didFinishAuthorizing()
                    }, failure: { error in
                        self.presenter?.presentError(title: error.title, message: error.message)
                    })
                }
            }, failure: { error in
                self.presenter?.presentError(title: error.title, message: error.message)
            })
        }
    }
}
