//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let closeTitle: String = NSLocalizedString("Close", comment: "")
    static let doneTitle: String = NSLocalizedString("Done", comment: "")
    static let navigationTitle: String = NSLocalizedString("compose.navigation.title", comment: "")
}

@objc protocol ComposeControlling: class {
    func setUpImageView(withImage image: UIImage)
    func showImagePicker()
    func closeImagePicker()
    func showSendingStatus()
    func hideSendingStatus()
}

final class ComposeViewController: UIViewController, HavingNib {
    static var nibName: String = "ComposeViewController"

    @IBOutlet fileprivate weak var composeImageView: UIImageView!
    @IBOutlet fileprivate weak var composeTextView: AutoexpandableTextView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var composeView: UIView!
    
    fileprivate let interactor: ComposeInteracting & ImagePicking
    fileprivate var keyboardHandler: KeyboardHandler!
    fileprivate var imagePicker: UIImagePickerController!
    fileprivate var activityPresenter: PresentingActivity!
    fileprivate var doneButton: UIBarButtonItem!
    
    init(interactor: ComposeInteracting & ImagePicking) {
        self.interactor = interactor
        super.init(nibName: ComposeViewController.nibName, bundle: nil)
        interactor.viewController = self
        interactor.errorPresenter = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpNavigationBar() {
        let close = UIBarButtonItem(title: Constants.closeTitle,
                                    style: .plain,
                                    target: interactor,
                                    action: #selector(ComposeInteracting.didTapClose))
        let done = UIBarButtonItem(title: Constants.doneTitle,
                                    style: .done,
                                    target: self,
                                    action: #selector(didTapDone))
        doneButton = done
        navigationItem.leftBarButtonItem = close
        navigationItem.rightBarButtonItem = done
        navigationItem.title = Constants.navigationTitle
    }
    
    fileprivate func setUpImageView() {
        composeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: interactor, action: #selector(ComposeInteracting.didTapImage))
        composeImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func didTapDone() {
        interactor.didTapDone(message: composeTextView.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(keyboardHandler: KeyboardHandler(scrollView: scrollView, animateOnStart: true, dismissOnTouch: true))
        setUp(imagePicker: UIImagePickerController())
        setUp(activityPresenter: ServiceLocator.activityPresenter)
        setUpNavigationBar()
        setUpImageView()
    }
}

extension ComposeViewController {
    fileprivate func setUp(keyboardHandler: KeyboardHandler) {
        self.keyboardHandler = keyboardHandler
        keyboardHandler.maximumVisibleY = view.frame.maxY
    }
    
    fileprivate func setUp(imagePicker: UIImagePickerController) {
        self.imagePicker = imagePicker
        imagePicker.delegate = interactor
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    
    fileprivate func setUp(activityPresenter: PresentingActivity) {
        self.activityPresenter = activityPresenter
    }
}

extension ComposeViewController: ComposeControlling {
    func setUpImageView(withImage image: UIImage) {
        composeImageView.image = image
    }
    
    func showImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func closeImagePicker() {
        dismiss(animated: true, completion: nil)
    }
    
    func showSendingStatus() {
        doneButton.isEnabled = false
        composeImageView.isUserInteractionEnabled = false
        activityPresenter.presentActivity(inView: view)
    }
    
    func hideSendingStatus() {
        doneButton.isEnabled = true
        composeImageView.isUserInteractionEnabled = true
        activityPresenter.dismissActivity(inView: view)
    }
}
