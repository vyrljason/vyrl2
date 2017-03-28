//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var ibBorderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var ibBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var ibCornerRadiusOfRoundedRect: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var ibCircleShape: Bool {
        get {
            layoutIfNeeded()
            return layer.cornerRadius == bounds.width / 2
        }
        set {
            layoutIfNeeded()
            layer.cornerRadius = newValue ? bounds.width / 2 : 0
            layer.masksToBounds = layer.cornerRadius > 0
        }
    }
}
