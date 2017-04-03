//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

protocol SnapshotToChatRoomsConverting {
    func convert(snapshot: FIRDataSnapshot) -> [String: ChatRoom]
}

final class ChatRoomsSnapshotConverter: SnapshotToChatRoomsConverting {

    func convert(snapshot: FIRDataSnapshot) -> [String: ChatRoom] {
        var result = [String: ChatRoom]()

        guard snapshot.exists() else { return result }

        if let parseableDictionaries = snapshot.value as? [AnyHashable: [AnyHashable: Any]] {
            parseableDictionaries.forEach({ (key, valueDictionary) in
                if let room = ChatRoom(dictionary: valueDictionary), let roomId = key as? String {
                    result[roomId] = room
                }
            })
        } else if let parseableDictionary = snapshot.value as? [AnyHashable: Any],
            let room = ChatRoom(dictionary: parseableDictionary) {
            result[snapshot.key] = room
        }
        return result
    }
}
