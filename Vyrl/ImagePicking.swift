//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ImagePicking: class, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
}
