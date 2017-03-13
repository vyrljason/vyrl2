//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ContactInfoViewController: UIViewController, HavingNib {
    static let nibName: String = "ContactInfoViewController"

    private let interactor: ContactInfoInteracting
    private let formFactory: ContactInfoFormMaking.Type
    fileprivate var keyboardHandler: KeyboardHandler!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var email: FormView!
    @IBOutlet private weak var phone: FormView!

    init(interactor: ContactInfoInteracting, formFactory: ContactInfoFormMaking.Type) {
        self.interactor = interactor
        self.formFactory = formFactory
        super.init(nibName: ContactInfoViewController.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(keyboardHandler: KeyboardHandler(scrollView: scrollView, dismissOnTouch: false))
        interactor.didPrepare(form: formFactory.make(fields: [email, phone]))
    }

    @IBAction private func didTapCancel() {
        view.endEditing(true)
        interactor.didTapCancel()
    }

    @IBAction private func didTapDone() {
        interactor.didTapAction()
    }
}

extension ContactInfoViewController {
    func setUp(keyboardHandler: KeyboardHandler) {
        self.keyboardHandler = keyboardHandler
        keyboardHandler.maximumVisibleY = view.frame.maxY
        keyboardHandler.animateOnStart = true
    }
}
