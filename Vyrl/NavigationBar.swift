//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct NavigationBarRenderable {
    let tintColor: UIColor
    let titleFont: UIFont
    let backgroundColor: UIColor
    let translucent: Bool
}

protocol NavigationBarRendering {
    func render(_ renderable: NavigationBarRenderable)
}

extension UINavigationController: NavigationBarRendering {
    func render(_ renderable: NavigationBarRenderable) {
        navigationBar.barTintColor = renderable.backgroundColor
        navigationBar.isTranslucent = renderable.translucent
        navigationBar.tintColor = renderable.tintColor
        navigationBar.titleTextAttributes = [NSFontAttributeName: renderable.titleFont,
                                             NSForegroundColorAttributeName: renderable.tintColor]
    }
}

struct NavigationItemRenderable {
    let titleImage: UIImage
}

protocol NavigationItemRendering {
    func render(_ renderable: NavigationItemRenderable)
}

extension UIViewController: NavigationItemRendering {
    func render(_ renderable: NavigationItemRenderable) {
        navigationItem.titleView = UIImageView(image: renderable.titleImage)
    }
}

protocol BackButtonHiding {
    func hideBackButton()
}

extension UIViewController: BackButtonHiding {
    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
}
