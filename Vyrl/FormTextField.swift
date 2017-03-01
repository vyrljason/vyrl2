//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

@IBDesignable
final class FormTextField: UITextField {
    private enum Constants {
        static let activeBorderHeight: CGFloat = 2
        static let inactiveBorderHeight: CGFloat = 1
    }

    @IBInspectable var activeUnderlineColor: UIColor = UIColor.dullWhite
    @IBInspectable var inactiveUnderlineColor: UIColor = UIColor.dullBlack

    private var bottomBorder: CALayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawBorder(using: inactiveUnderlineColor, with: Constants.inactiveBorderHeight)
        borderStyle = .none
    }

    override func becomeFirstResponder() -> Bool {
        drawBorder(using: activeUnderlineColor, with: Constants.activeBorderHeight)
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        drawBorder(using: inactiveUnderlineColor, with: Constants.inactiveBorderHeight)
        return super.resignFirstResponder()
    }

    private func drawBorder(using color: UIColor, with height: CGFloat) {
        if let border = bottomBorder {
            border.removeFromSuperlayer()
        }
        bottomBorder = layer.drawBottomBorder(for: self, using: color, with: height)
    }

    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            guard let placeholder = placeholder, let placeholderColor = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: placeholderColor])
        }
    }

    override var placeholder: String? {
        didSet {
            guard let placeholder = placeholder, let placeholderColor = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: placeholderColor])
        }
    }
}
