//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private struct Constants {
    static let actionName = NSLocalizedString("signIn.button.title", comment: "")
}

final class SignUpViewController: UIViewController, HavingNib {
    static let nibName: String = "SignUpViewController"
    
    private var interactor: SignUpInteracting
    private let formFactory: SignUpFormMaking.Type
    fileprivate var keyboardHandler: KeyboardHandler!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var vyrlUsername: FormView!
    @IBOutlet private weak var email: FormView!
    @IBOutlet private weak var emailConfirmation: FormView!
    @IBOutlet private weak var password: FormView!
    @IBOutlet private weak var instagramUsername: FormView!
    
    @IBOutlet private weak var formHeaderLabel: UILabel!
    @IBOutlet private weak var passwordFooter: UILabel!
    @IBOutlet private weak var isBrandSwitch: UISwitch!
    @IBOutlet private weak var formFooterLabel: UILabel!
    @IBOutlet private weak var fixedTOCandPrivcayLabel: UILabel!
    fileprivate var tocPrivacyLabelGestureRecognizer: UITapGestureRecognizer?
    fileprivate var activityPresenter: PresentingActivity!

    @IBOutlet weak var submitButton: UIButton!
    
    init(interactor: SignUpInteracting, formFactory: SignUpFormMaking.Type) {
        self.interactor = interactor
        self.formFactory = formFactory
        super.init(nibName: SignUpViewController.nibName, bundle: nil)
        self.interactor.activityIndicatorPresenter = self
        self.interactor.errorPresenter = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(activityPresenter: ServiceLocator.activityPresenter)
        setUp(keyboardHandler: KeyboardHandler(scrollView: scrollView, dismissOnTouch: false))
        setUpGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let form = formFactory.make(fields: [vyrlUsername, email, emailConfirmation, password, instagramUsername])
        interactor.didPrepare(form: form)
        super.viewDidAppear(animated)
    }
    
    fileprivate func setUp(activityPresenter: PresentingActivity) {
        self.activityPresenter = activityPresenter
    }
    
    func setUpGestureRecognizers() {
        if let tocPrivacyLabelGestureRecognizer = tocPrivacyLabelGestureRecognizer, tocPrivacyLabelGestureRecognizer.view == fixedTOCandPrivcayLabel {
            // recognizer already there
            return
        }
        tocPrivacyLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.didTapTOCAndPrivacyLabel))
        if let tocPrivacyLabelGestureRecognizer = tocPrivacyLabelGestureRecognizer {
            fixedTOCandPrivcayLabel.addGestureRecognizer(tocPrivacyLabelGestureRecognizer)
        }
    }
    
    @IBAction private func didTapSubmit() {
        if isBrandSwitch.isOn {
            navigationController?.popViewController(animated: true)
            // disabled for brick wall
//            interactor.didTapSubmitAsBrand()
        } else {
            interactor.didTapSubmit()
        }
    }
    
    func didTapTOCAndPrivacyLabel() {
        interactor.didTapTocAndPrivacy()
    }
}

extension SignUpViewController: ActivityIndicatorPresenter {
    func presentActivity() {
        activityPresenter.presentActivity(inView: view)
    }
    
    func dismissActivity() {
        activityPresenter.dismissActivity(inView: view)
    }
}

extension SignUpViewController {
    func setUp(keyboardHandler: KeyboardHandler) {
        self.keyboardHandler = keyboardHandler
        keyboardHandler.maximumVisibleY = view.frame.maxY
        keyboardHandler.animateOnStart = true
    }
}
