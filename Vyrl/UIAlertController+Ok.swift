//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: .alert)

        let titleOK = NSLocalizedString("general.button.alert.ok", comment: "")
        let action = UIAlertAction(title: titleOK, style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        addAction(action)
    }
}
