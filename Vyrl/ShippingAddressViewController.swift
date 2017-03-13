//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ShippingAddressViewController: UIViewController, HavingNib {
    static let nibName: String = "ShippingAddressViewController"

    private let interactor: ShippingAddressInteracting & FormActionDelegate
    private let formFactory: ShippingAddressFormMaking.Type
    fileprivate var keyboardHandler: KeyboardHandler!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var street: FormView!
    @IBOutlet private weak var apartment: FormView!
    @IBOutlet private weak var city: FormView!
    @IBOutlet private weak var state: FormView!
    @IBOutlet private weak var zip: FormView!
    @IBOutlet private weak var country: FormView!

    init(interactor: ShippingAddressInteracting & FormActionDelegate, formFactory: ShippingAddressFormMaking.Type) {
        self.interactor = interactor
        self.formFactory = formFactory
        super.init(nibName: ShippingAddressViewController.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(keyboardHandler: KeyboardHandler(scrollView: scrollView, dismissOnTouch: false))
        let form = formFactory.make(fields: [street, apartment, city, state, zip, country], actionDelegate: interactor)
        interactor.didPrepare(form: form)
    }

    @IBAction private func didTapCancel() {
        view.endEditing(true)
        interactor.didTapCancel()
    }

    @IBAction private func didTapDone() {
        view.endEditing(true)
        interactor.didTapAction()
    }
}

extension ShippingAddressViewController {
    func setUp(keyboardHandler: KeyboardHandler) {
        self.keyboardHandler = keyboardHandler
        keyboardHandler.maximumVisibleY = view.frame.maxY
        keyboardHandler.animateOnStart = true
    }
}
