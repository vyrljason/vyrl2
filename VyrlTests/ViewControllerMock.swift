//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ViewControllerMock: UIViewController {
    var navigationMock = NavigationItemMock()
    override var navigationItem: UINavigationItem {
        return navigationMock
    }
}
