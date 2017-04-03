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
    
    init(interactor: ComposeInteracting & ImagePicking) {
        self.interactor = interactor
        super.init(nibName: ComposeViewController.nibName, bundle: nil)
        interactor.viewController = self
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
                                    target: interactor,
                                    action: #selector(ComposeInteracting.didTapDone))
        navigationItem.leftBarButtonItem = close
        navigationItem.rightBarButtonItem = done
        navigationItem.title = Constants.navigationTitle
    }
    
    fileprivate func setUpImageView() {
        composeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: interactor, action: #selector(ComposeInteracting.didTapImage))
        composeImageView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(keyboardHandler: KeyboardHandler(scrollView: scrollView, dismissOnTouch: true))
        setUp(imagePicker: UIImagePickerController())
        setUpNavigationBar()
        setUpImageView()
    }
}

extension ComposeViewController {
    fileprivate func setUp(keyboardHandler: KeyboardHandler) {
        self.keyboardHandler = keyboardHandler
        keyboardHandler.maximumVisibleY = composeView.bounds.maxY
        keyboardHandler.animateOnStart = true
    }
    
    fileprivate func setUp(imagePicker: UIImagePickerController) {
        self.imagePicker = imagePicker
        imagePicker.delegate = interactor
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
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
}
