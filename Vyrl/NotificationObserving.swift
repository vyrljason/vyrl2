//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol NotificationObserving: class {
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
}

extension NotificationCenter: NotificationObserving { }
