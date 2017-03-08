//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension UITextView {
    func removeInsets() {
        textContainer.lineFragmentPadding = 0
        contentInset = UIEdgeInsets.zero
        textContainerInset = UIEdgeInsets.zero
    }
}
