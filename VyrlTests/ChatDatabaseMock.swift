//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import Firebase

final class ChatDatabaseMock: ChatDatabaseChildAccessing, ChatDatabaseObserving {

    var child: ChatDatabaseMock!
    var didCallObserved = false
    var snapshot = FIRDataSnapshot()

    func childAt(path: String) -> ChatDatabaseChildAccessing & ChatDatabaseObserving {
        return child
    }

    func observe(_ eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Void) -> UInt {
        didCallObserved = true
        block(snapshot)
        return 0
    }

    func removeObserver(withHandle handle: UInt) { }

    func removeAllObservers() { }
}
