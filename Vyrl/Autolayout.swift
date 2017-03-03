//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AnchorsHaving {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
}

protocol ViewContainer: class, AnchorsHaving {
    var container: UIView { get }
    var subviews: [UIView] { get }
}

protocol PinningToEdges {
    func pinToEdges(of layoutableViewContainer: ViewContainer & AnchorsHaving)
}

extension UIView: PinningToEdges {
    func pinToEdges(of layoutableViewContainer: ViewContainer & AnchorsHaving) {
        layoutableViewContainer.container.addSubview(self)
        topAnchor.constraint(equalTo: layoutableViewContainer.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: layoutableViewContainer.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: layoutableViewContainer.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: layoutableViewContainer.bottomAnchor).isActive = true
    }
}

extension UIView {
    func set(height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func set(width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}

protocol ViewHaving {
    var view: UIView! { get }
}

extension UIViewController: ViewHaving {}

extension ViewContainer {
    var subviews: [UIView] { return container.subviews }
}

extension UIViewController: ViewContainer {
    var container: UIView { return view }
}

extension UIView: ViewContainer {
    var container: UIView { return self }
}

protocol RemovingFromSuperview {
    func removeFromSuperview()
}

extension UIView: RemovingFromSuperview { }

extension UIView: AnchorsHaving { }

extension UIViewController: AnchorsHaving {
    var leadingAnchor: NSLayoutXAxisAnchor { return view.leadingAnchor }
    var trailingAnchor: NSLayoutXAxisAnchor { return view.trailingAnchor }
    var topAnchor: NSLayoutYAxisAnchor { return topLayoutGuide.topAnchor }
    var bottomAnchor: NSLayoutYAxisAnchor { return bottomLayoutGuide.bottomAnchor }
}

protocol ViewControllerPresenting: class {
    var presentedViewController: UIViewController? { get }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: ViewControllerPresenting { }

protocol LayoutGuideHaving: class {
    var topLayoutGuide: UILayoutSupport { get }
    var bottomLayoutGuide: UILayoutSupport { get }
}

extension UIViewController: LayoutGuideHaving { }
