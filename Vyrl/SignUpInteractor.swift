//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SignUpInteracting {
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    func didPrepare(form: SignUpFormInteracting)
    func didTapTocAndPrivacy()
    func didTapSubmitAsBrand()
    func didTapSubmit()
}

final class SignUpInteractor: SignUpInteracting {

    private var form: SignUpFormInteracting?
    fileprivate let apiConfiguration: APIConfigurationHaving
    fileprivate let signUpService: SignUpService

    weak var errorPresenter: ErrorAlertPresenting?
    weak var webviewPresenter: WebviewPresenting?

    weak var signUpNavigation: AuthorizationNavigating?


    init(signUpService: SignUpService, apiConfiguration: APIConfigurationHaving) {
        self.signUpService = signUpService
        self.apiConfiguration = apiConfiguration
    }
    
    func didPrepare(form: SignUpFormInteracting) {
        self.form = form
    }

    func didTapSubmitAsBrand() {
        webviewPresenter?.presentWebview(with: apiConfiguration.mainBaseURL, animated: true)
    }
    
    func didTapSubmit() {
        guard let form = form else { return }
        if case .invalid(let errorMessage) = form.status {
            errorPresenter?.presentError(title: nil, message: errorMessage)
            return
        }
        guard let signUpData = form.result else { return }

        let signUpRequest = UserSignUpRequest(username: signUpData.username, email: signUpData.email, password: signUpData.password, platformUsername: signUpData.platformUsername)
        signUpService.signUp(using: signUpRequest) { [weak self] apiResult in
            guard let `self` = self else { return }
            apiResult.on(success: { userToken in
                // sign up complete
                self.signUpNavigation?.didFinishRegistration()
            }, failure: { error in
                self.errorPresenter?.presentError(title: error.title, message: error.message)
            })
        }
    }
    
    func didTapTocAndPrivacy() {
        webviewPresenter?.presentWebview(with: apiConfiguration.tosURL, animated: true)
    }
}
