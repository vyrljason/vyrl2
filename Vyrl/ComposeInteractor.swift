//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let failedToSentMessage = NSLocalizedString("messages.error.failedToSend", comment: "")
}

@objc protocol ComposeInteracting {
    weak var composeCloser: ComposeClosing? { get set }
    weak var viewController: ComposeControlling? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    func didTapClose()
    func didTapDone(message: String)
    func didTapImage()
}

final class ComposeInteractor: NSObject, ComposeInteracting {
    
    weak var composeCloser: ComposeClosing?
    weak var viewController: ComposeControlling?
    weak var errorPresenter: ErrorAlertPresenting?
    
    fileprivate let messageSender: ImageMessageSending
    fileprivate let collab: Collab
    
    var selectedImage: UIImage?
    
    init(collab: Collab, messageSender: ImageMessageSending) {
        self.collab = collab
        self.messageSender = messageSender
    }
    
    @objc func didTapClose() {
        composeCloser?.finishPresentation()
    }
    
    @objc func didTapDone(message: String) {
        guard let selectedImage = selectedImage, message.characters.count > 0 else { return }
        viewController?.showSendingStatus()
        messageSender.send(message: message, withImage: selectedImage, toCollab: collab) { [weak self] result in
            result.on(success: { _ in
                self?.viewController?.hideSendingStatus()
                self?.composeCloser?.finishPresentation()
            }, failure: { _ in
                self?.viewController?.hideSendingStatus()
                self?.errorPresenter?.presentError(title: nil, message: Constants.failedToSentMessage)
            })
        }
    }
    
    @objc func didTapImage() {
        viewController?.showImagePicker()
    }
}

extension ComposeInteractor: ImagePicking {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.closeImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = pickedImage
            viewController?.setUpImageView(withImage: pickedImage)
        }
        viewController?.closeImagePicker()
    }
}
