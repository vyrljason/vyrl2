//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static func onMainThread(execute closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
            return
        }
        DispatchQueue.main.async(execute: closure)
    }
}
