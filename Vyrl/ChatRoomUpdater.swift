//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

private enum Constants {
    static let messagesPathPrefix = "chats/messages/"
}

protocol ChatRoomUpdatesInforming {
    func listenToNewMessages(inRoom roomId: String, completion: @escaping ([MessageContainer]) -> Void)
    func stopListening(inRoom roomId: String)
}

final class ChatRoomUpdater: ChatRoomUpdatesInforming {

    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving
    private var messagesHandler: FIRDatabaseHandle?
    private let dataConverter: SnapshotToMessagesConverting

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving,
         dataConverter: SnapshotToMessagesConverting = MessagesSnapshotConverter()) {
        self.chatDatabase = chatDatabase
        self.dataConverter = dataConverter
    }

    func listenToNewMessages(inRoom roomId: String, completion: @escaping ([MessageContainer]) -> Void) {
        messagesHandler = chatDatabase.childAt(path: messagesPath(for: roomId)).observe(.childAdded, with: { [weak self] (snapshot) in
            guard let `self` = self else { return }
            print("added")
            let result = self.dataConverter.convert(snapshot: snapshot)
            completion(result)
        })
    }

    func stopListening(inRoom roomId: String) {
        guard let handler = messagesHandler else { return }
        chatDatabase.childAt(path: messagesPath(for: messagesPath(for: roomId))).removeObserver(withHandle: handler)
    }

    private func messagesPath(for roomId: String) -> String {
        return Constants.messagesPathPrefix + roomId
    }
}
