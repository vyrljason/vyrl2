//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ClosureBarButtonItem: UIBarButtonItem {
    
    fileprivate var actionClosure: (() -> Void)?
    
    class func barButtonItem(image: UIImage,
                             style: UIBarButtonItemStyle = .plain,
                             action: @escaping () -> Void) -> ClosureBarButtonItem {
        let barButtonItem = ClosureBarButtonItem(image: image, style: style, target: self,
                                                 action: #selector(ClosureBarButtonItem.buttonAction(sender:)))
        barButtonItem.actionClosure = action
        return barButtonItem
    }
    
    class func barButtonItem(title: String,
                             style: UIBarButtonItemStyle = .plain,
                             action: @escaping () -> Void) -> ClosureBarButtonItem {
        let barButtonItem = ClosureBarButtonItem(title: title, style: style, target: self,
                                                 action: #selector(ClosureBarButtonItem.buttonAction(sender:)))
        barButtonItem.actionClosure = action
        return barButtonItem
    }
    
    class func buttonAction(sender: ClosureBarButtonItem) {
        if let action = sender.actionClosure {
            action()
        }
    }
}
