//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol NavigationHaving {
    var navigationController: UINavigationController { get }
    func resetNavigation()
    func dismissModalFlow()
}
