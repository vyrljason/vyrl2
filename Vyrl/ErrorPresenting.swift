//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ErrorAlertPresenting: class {
    func presentError(title: String?, message: String?)
}

extension UIViewController: ErrorAlertPresenting {
    func presentError(title: String?, message: String?) {
        let controller = UIAlertController(title: title, message: message)
        present(controller, animated: true, completion: nil)
    }
}
