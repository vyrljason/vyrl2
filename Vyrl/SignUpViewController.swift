//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private struct Constants {
    static let actionName = NSLocalizedString("signIn.button.title", comment: "")
}

final class SignUpViewController: UIViewController, HavingNib {
    static let nibName: String = "SignUpViewController"
    
    private let interactor: SignUpInteracting
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
    
    @IBOutlet weak var submitButton: UIButton!
    
    init(interactor: SignUpInteracting, formFactory: SignUpFormMaking.Type) {
        self.interactor = interactor
        self.formFactory = formFactory
        super.init(nibName: SignUpViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let form = formFactory.make(fields: [vyrlUsername, email, emailConfirmation, password, instagramUsername])
        interactor.didPrepare(form: form)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(keyboardHandler: KeyboardHandler(scrollView: scrollView, dismissOnTouch: false))
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
