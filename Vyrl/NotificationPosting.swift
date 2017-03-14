//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol NotificationPosting: class {
    func post(name aName: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]?)
}

extension NotificationCenter: NotificationPosting { }
