//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SignUpInteracting {
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    func didPrepare(form: SignUpFormInteracting)
    func didTapTocAndPrivacy()
    func didTapSubmit()
}

final class SignUpInteractor: SignUpInteracting {

    private var form: SignUpFormInteracting?
    fileprivate let apiConfiguration: APIConfigurationHaving
    weak var errorPresenter: ErrorAlertPresenting?
    weak var webviewPresenter: WebviewPresenting?

    weak var signUpNavigation: AuthorizationNavigating?

    init(apiConfiguration: APIConfigurationHaving) {
        self.apiConfiguration = apiConfiguration
    }
    
    func didPrepare(form: SignUpFormInteracting) {
        self.form = form
    }

    func didTapSubmit() {
        guard let form = form else { return }
        if case .invalid(let errorMessage) = form.status {
            errorPresenter?.presentError(title: nil, message: errorMessage)
            return
        }
        guard let _ = form.result else { return }
        //TODO: call Service to execute networking call
    }
    
    func didTapTocAndPrivacy() {
        webviewPresenter?.presentWebview(with: apiConfiguration.tosURL, animated: true)
    }
}
