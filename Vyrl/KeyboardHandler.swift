//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class KeyboardHandler: NSObject {

    fileprivate var dismissKeyboardRecognizer: UITapGestureRecognizer?
    fileprivate unowned var scrollView: UIScrollView

    //Reflects to what Y user should be able to scroll in the VC
    var maximumVisibleY: CGFloat
    var animateOnStart: Bool
    private let dismissOnTouch: Bool

    fileprivate var initialContentInsets: UIEdgeInsets?

    init(scrollView: UIScrollView,
         maximumVisibleY: CGFloat = 0,
         animateOnStart: Bool = false,
         dismissOnTouch: Bool = true) {
        self.scrollView = scrollView
        self.maximumVisibleY = maximumVisibleY
        self.animateOnStart = animateOnStart
        self.dismissOnTouch = dismissOnTouch
        super.init()
        if dismissOnTouch {
            setupDismissTapRecognizer()
        }
        setupKeyboardNotifications()
    }

    private func setupDismissTapRecognizer() {
        dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(KeyboardHandler.dismissKeyboard))
        guard let recognizer = dismissKeyboardRecognizer else { return }
        scrollView.addGestureRecognizer(recognizer)
        recognizer.cancelsTouchesInView = false
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHandler.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHandler.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func dismissKeyboard() {
        scrollView.superview?.endEditing(true)
    }

    fileprivate func calculateRequiredOffset(maximumVisibleY: CGFloat?,
                                             keyboardInfo: [AnyHashable : Any]?) -> CGFloat {
        guard let keyboardFrame = keyboardInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return 0 }
        let requiredVisibleY    = maximumVisibleY ?? scrollView.frame.height
        let freeSpaceOnScreen   = max(scrollView.frame.height - requiredVisibleY, 0)
        let keyboardHeight      = keyboardFrame.cgRectValue.height
        let keyboardOffset      = freeSpaceOnScreen >= keyboardHeight ? 0 : keyboardHeight - freeSpaceOnScreen
        return keyboardOffset
    }

    func animate(contentOffsetY: CGFloat, keyboardInfo: [AnyHashable : Any]?) {
        UIView.beginAnimations(nil, context: nil)
        if let duration = keyboardInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            UIView.setAnimationDuration(duration)
        }
        if let curve = keyboardInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
        }
        UIView.setAnimationBeginsFromCurrentState(true)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: contentOffsetY)
        UIView.commitAnimations()
    }

    @objc func keyboardWillShow(notification: Notification) {
        let keyboardOffset = calculateRequiredOffset(maximumVisibleY: maximumVisibleY, keyboardInfo: notification.userInfo)

        initialContentInsets = scrollView.contentInset
        let contentInset = UIEdgeInsets(top: scrollView.contentInset.top,
                                        left: scrollView.contentInset.left,
                                        bottom: keyboardOffset,
                                        right: scrollView.contentInset.right)
        scrollView.scrollIndicatorInsets  = contentInset
        scrollView.contentInset           = contentInset

        if animateOnStart {
            animate(contentOffsetY: keyboardOffset, keyboardInfo: notification.userInfo)
        }
        dismissKeyboardRecognizer?.isEnabled = true

    }

    @objc func keyboardWillHide(notification: Notification) {
        let contentInset: UIEdgeInsets = initialContentInsets ?? .zero
        scrollView.scrollIndicatorInsets    = contentInset
        scrollView.contentInset             = contentInset
        scrollView.setContentOffset(.zero, animated: animateOnStart)
        dismissKeyboardRecognizer?.isEnabled = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
