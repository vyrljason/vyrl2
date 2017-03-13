//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension UIViewController {
    private var leftButtonNegativeSpace: CGFloat {
        return -8.0
    }
    
    func renderNoTitleBackButton() {
        let backButton = ClosureBarButtonItem.barButtonItem(image: #imageLiteral(resourceName: "back_button")) { [weak self] in
            let _ = self?.navigationController?.popViewController(animated: true)
        }
        let negativeButton      = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeButton.width    = leftButtonNegativeSpace
        navigationItem.leftBarButtonItems = [negativeButton, backButton]
    }
}
