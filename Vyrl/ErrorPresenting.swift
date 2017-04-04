//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let okTitle = NSLocalizedString("general.button.alert.ok", comment: "")
}

@objc protocol ErrorAlertPresenting: class {
    func presentError(title: String?, message: String?)
}

extension UIViewController: ErrorAlertPresenting {
    func presentError(title: String?, message: String?) {
        let controller = UIAlertController(title: title, message: message)
        let action = UIAlertAction(title: Constants.okTitle, style: .cancel, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
}
