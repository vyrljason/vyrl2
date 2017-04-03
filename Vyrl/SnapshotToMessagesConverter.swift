//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

protocol SnapshotToMessagesConverting {
    func convert(snapshot: FIRDataSnapshot) -> [MessageContainer]
}

final class MessagesSnapshotConverter: SnapshotToMessagesConverting {

    func convert(snapshot: FIRDataSnapshot) -> [MessageContainer] {
        guard snapshot.exists() else { return [] }
        if let parseableRoomsDictionary = snapshot.value as? [AnyHashable: [AnyHashable: Any]] {
            return parseableRoomsDictionary.flatMap({ (_, valueDictionary) in
                return try? MessageContainer.decode(valueDictionary)
            })
        } else if let snapshotValue = snapshot.value,
            let decodedMessage = try? MessageContainer.decode(snapshotValue) {
            return [decodedMessage]
        } else {
            return []
        }
    }
}
