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
    fileprivate var placeholderLabel: UILabel!
    fileprivate var notificationObserver: NotificationObserving = NotificationCenter.default

    override var attributedText: NSAttributedString! {
        didSet {
            updateHeight()
            if placeholderLabel != nil {
                placeholderLabel.isHidden = !attributedText.string.isEmpty
            }
        }
    }
    
    override var text: String! {
        didSet {
            updateHeight()
            if placeholderLabel != nil {
                placeholderLabel.isHidden = !text.isEmpty
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateHeight()
        setUpPlaceholder()
        notificationObserver.addObserver(self, selector: #selector(didChangeText), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    func updateHeight() {
        let heightThatFits = sizeThatFits(CGSize(width: frame.width, height: frame.height)).height
        height?.constant = min(heightThatFits, maxHeight)
        superview?.layoutIfNeeded()
    }
    
    func didChangeText() {
        placeholderLabel.isHidden = !text.isEmpty
        updateHeight()
    }
    
    func setUpPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.font = font
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (font?.pointSize ?? 1.0) / 2)
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}
