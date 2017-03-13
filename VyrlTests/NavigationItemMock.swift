//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class NavigationItemMock: UINavigationItem {
    var didSetRightBarButtonItems: Bool = false
    var didSetLeftBarButtonItems: Bool = false
    var rightBarButtonItemsArgument: [UIBarButtonItem]?
    var leftBarButtonItemsArgument: [UIBarButtonItem]?
    
    override var leftBarButtonItems: [UIBarButtonItem]? {
        didSet {
            didSetLeftBarButtonItems = true
            leftBarButtonItemsArgument = leftBarButtonItems
        }
    }
    
    override var rightBarButtonItems: [UIBarButtonItem]? {
        didSet {
            didSetRightBarButtonItems = true
            rightBarButtonItemsArgument = rightBarButtonItems
        }
    }
}
