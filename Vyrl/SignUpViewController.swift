//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController, HavingNib {
    static let nibName: String = "SignUpViewController"

    private let interactor: SignUpInteracting
    private let formFactory: SignUpFormMaking.Type
    fileprivate var keyboardHandler: KeyboardHandler!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var username: FormView!
    @IBOutlet private weak var email: FormView!
    //TODO: add rest of required FormViews

    init(interactor: SignUpInteracting, formFactory: SignUpFormMaking.Type) {
        self.interactor = interactor
        self.formFactory = formFactory
        super.init(nibName: SignUpViewController.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(keyboardHandler: KeyboardHandler(scrollView: scrollView, dismissOnTouch: false))
        let form = formFactory.make(fields: [username, email])
        interactor.didPrepare(form: form)
    }

    @IBAction private func didTapSubmit() {
        interactor.didTapSubmit()
    }
}

extension SignUpViewController {
    func setUp(keyboardHandler: KeyboardHandler) {
        self.keyboardHandler = keyboardHandler
        keyboardHandler.maximumVisibleY = view.frame.maxY
        keyboardHandler.animateOnStart = true
    }
}
