//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class UnselectableTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = UIColor.clear
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
