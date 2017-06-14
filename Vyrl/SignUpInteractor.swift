//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SignUpInteracting {
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    weak var webviewPresenter: WebviewPresenting? { get set }
    weak var signUpNavigation: AuthorizationNavigating? { get set }
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter? { get set }
    
    func didPrepare(form: SignUpFormInteracting)
    func didTapTocAndPrivacy()
    func didTapSubmitAsBrand()
    func didTapSubmit()
}

final class SignUpInteractor: SignUpInteracting {

    private var form: SignUpFormInteracting?
    fileprivate let apiConfiguration: APIConfigurationHaving
    fileprivate let signUpService: UserSignUpProviding

    weak var errorPresenter: ErrorAlertPresenting?
    weak var webviewPresenter: WebviewPresenting?

    weak var signUpNavigation: AuthorizationNavigating?
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter?

    init(signUpService: UserSignUpProviding, apiConfiguration: APIConfigurationHaving) {
        self.signUpService = signUpService
        self.apiConfiguration = apiConfiguration
    }
    
    func didPrepare(form: SignUpFormInteracting) {
        self.form = form
    }

    func didTapSubmitAsBrand() {

        // disabled for brick wall behavior
//        webviewPresenter?.presentWebview(with: apiConfiguration.mainBaseURL, animated: true)
    }
    
    func didTapSubmit() {
        activityIndicatorPresenter?.presentActivity()
        guard let form = form else { return }
        
        if case .invalid(let errorMessage) = form.status {
            activityIndicatorPresenter?.dismissActivity()
            errorPresenter?.presentError(title: nil, message: errorMessage)
            return
        }
        guard let signUpData = form.result else {
            activityIndicatorPresenter?.dismissActivity()
            return
        }

        let signUpRequest = UserSignUpRequest(username: signUpData.username, email: signUpData.email, password: signUpData.password, platformUsername: signUpData.platformUsername)
        signUpService.signUp(using: signUpRequest) { [weak self] apiResult in
            guard let `self` = self else { return }
            apiResult.on(success: { userProfile in
                // sign up complete
                self.signUpNavigation?.didFinishRegistration(userProfile)
                self.activityIndicatorPresenter?.dismissActivity()
            }, failure: { error in
                self.errorPresenter?.presentError(title: error.title, message: error.message)
                self.activityIndicatorPresenter?.dismissActivity()
            })
        }
    }
    
    func didTapTocAndPrivacy() {
        webviewPresenter?.presentWebview(with: apiConfiguration.tosURL, animated: true)
    }
}
