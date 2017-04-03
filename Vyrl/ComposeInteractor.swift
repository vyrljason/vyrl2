//
//  ComposeInteractor.swift
//  Vyrl
//
//  Created by Wojciech Stasiński on 03/04/2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

@objc protocol ComposeInteracting {
    weak var composeCloser: ComposeClosing? { get set }
    weak var viewController: ComposeControlling? { get set }
    func didTapClose()
    func didTapDone()
    func didTapImage()
}

final class ComposeInteractor: NSObject, ComposeInteracting {
    
    weak var composeCloser: ComposeClosing?
    weak var viewController: ComposeControlling?
    
    @objc func didTapClose() {
        composeCloser?.finishPresentation()
    }
    
    @objc func didTapDone() {
        composeCloser?.finishPresentation()
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
            viewController?.setUpImageView(withImage: pickedImage)
        }
        viewController?.closeImagePicker()
    }
}
