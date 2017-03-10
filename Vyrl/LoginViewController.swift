//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ViewActivityPresenting {
    func presentActivity()
    func dismiss()
}

private struct Constants {
    static let actionName = NSLocalizedString("signIn.button.title", comment: "")
}

final class LoginViewController: UIViewController, HavingNib {
    static let nibName: String = "LoginViewController"

    private let interactor: LoginInteracting
    private let formMaker: LoginFormMaking.Type
    @IBOutlet private weak var username: FormTextField!
    @IBOutlet private weak var password: FormTextField!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!

    init(interactor: LoginInteracting, formMaker: LoginFormMaking.Type) {
        self.interactor = interactor
        self.formMaker = formMaker
        super.init(nibName: LoginViewController.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.didPrepare(form: formMaker.make(username: username, password: password))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = username.becomeFirstResponder()
    }
}

extension LoginViewController: ViewActivityPresenting {
    func presentActivity() {
        activityIndicator.startAnimating()
    }

    func dismiss() {
        activityIndicator.stopAnimating()
    }
}
