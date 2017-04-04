//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import Firebase

final class ChatDatabaseMock: ChatDatabaseChildAccessing, ChatDatabaseObserving, ChatDatabaseUpdating {

    var child: ChatDatabaseMock!
    var calledPath: String?
    var lastCalledValue: Any?
    var didCallObserved = false
    var didCallObservedSingleEvent = false
    var didCallRemoveObserver = false
    var snapshot = FIRDataSnapshot()

    func childAt(path: String) -> ChatDatabaseChildAccessing & ChatDatabaseObserving & ChatDatabaseUpdating {
        calledPath = path
        return child
    }

    func observe(_ eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Void) -> UInt {
        didCallObserved = true
        block(snapshot)
        return 0
    }

    func removeObserver(withHandle handle: UInt) {
        didCallRemoveObserver = true
    }

    func observeSingleEvent(of eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Swift.Void) {
        didCallObservedSingleEvent = true
        block(snapshot)
    }

    func removeAllObservers() { }

    func setValue(_ value: Any?) {
        lastCalledValue = value
    }
}
