//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Foundation

final class AutoexpandableTextView: UITextView {

    @IBOutlet fileprivate weak var height: NSLayoutConstraint?
    @IBInspectable var maxHeight: CGFloat = CGFloat(MAXFLOAT)
    @IBInspectable var placeholderTextColor: UIColor = UIColor.lightGray
    @IBInspectable var placeholderText: String = ""
    var placeholderLabel: UILabel!

    override var attributedText: NSAttributedString! {
        didSet {
            updateHeight()
        }
    }
    
    override var text: String! {
        didSet {
            updateHeight()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateHeight()
        setupPlaceholder()
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeText), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    func updateHeight() {
        let heightThatFits = sizeThatFits(CGSize(width: frame.width, height: frame.height)).height
        height?.constant = min(heightThatFits, maxHeight)
        superview?.layoutIfNeeded()
    }
    
    func didChangeText() {
        placeholderLabel.isHidden = !self.text.isEmpty
        updateHeight()
    }
    
    func setupPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        self.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
}
