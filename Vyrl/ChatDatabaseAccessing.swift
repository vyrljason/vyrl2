//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ChatDatabaseChildAccessing {
    func childAt(path: String) -> ChatDatabaseChildAccessing & ChatDatabaseObserving
}

protocol ChatDatabaseObserving {
    func observe(_ eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Void) -> UInt
    func removeObserver(withHandle handle: UInt)
    func removeAllObservers()
}

extension FIRDatabaseReference: ChatDatabaseObserving { }

extension FIRDatabaseReference: ChatDatabaseChildAccessing {
    func childAt(path: String) -> ChatDatabaseChildAccessing & ChatDatabaseObserving {
        return child(path)
    }
}
