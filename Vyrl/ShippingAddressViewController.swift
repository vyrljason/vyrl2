//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ShippingAddressViewController: UIViewController, HavingNib {
    static let nibName: String = "ShippingAddressViewController"

    private let interactor: ShippingAddressInteracting
    private let formFactory: ShippingAddressFormMaking.Type
    fileprivate var keyboardHandler: KeyboardHandler!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var lastFormView: FormView!
    @IBOutlet private weak var street: FormView!
    @IBOutlet private weak var apartment: FormView!
    @IBOutlet private weak var city: FormView!
    @IBOutlet private weak var state: FormView!
    @IBOutlet private weak var zip: FormView!
    @IBOutlet private weak var country: FormView!

    init(interactor: ShippingAddressInteracting, formFactory: ShippingAddressFormMaking.Type) {
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
        interactor.didPrepare(form: formFactory.make(fields: [street, apartment, city, state, zip, country]))
    }

    @IBAction private func didTapCancel() {
        interactor.didTapCancel()
    }

    @IBAction private func didTapDone() {
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
