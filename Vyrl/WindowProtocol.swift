//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol WindowProtocol: class {
    func makeKeyAndVisible()
    var isKeyWindow: Bool { get }
    var rootViewController: UIViewController? { get set }
}

extension UIWindow: WindowProtocol { }
