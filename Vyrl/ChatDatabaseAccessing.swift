//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ChatDatabaseChildAccessing {
    func childAt(path: String) -> ChatDatabaseChildAccessing & ChatDatabaseObserving & ChatDatabaseUpdating
}

protocol ChatDatabaseUpdating {
    func setValue(_ value: Any?)
}

protocol ChatDatabaseObserving {
    func observe(_ eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Void) -> UInt
    func observeSingleEvent(of eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Swift.Void)
    func removeObserver(withHandle handle: UInt)
    func removeAllObservers()
}

extension FIRDatabaseReference: ChatDatabaseObserving { }

extension FIRDatabaseReference: ChatDatabaseUpdating { }

extension FIRDatabaseReference: ChatDatabaseChildAccessing {
    func childAt(path: String) -> ChatDatabaseChildAccessing & ChatDatabaseObserving & ChatDatabaseUpdating {
        return child(path)
    }
}
