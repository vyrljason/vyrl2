//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

private enum Constants {
    static let messagesPathPrefix = "chats/messages/"
}

protocol MessagesProviding {
    func getMessages(inChatRoom chatRoomId: String, completion: @escaping ([MessageContainer]) -> Void)
}

final class MessagesService: MessagesProviding {

    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving
    private let dataConverter: SnapshotToMessagesConverting

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving,
         dataConverter: SnapshotToMessagesConverting = MessagesSnapshotConverter()) {
        self.chatDatabase = chatDatabase
        self.dataConverter = dataConverter
    }

    func getMessages(inChatRoom chatRoomId: String, completion: @escaping ([MessageContainer]) -> Void) {
        let path = Constants.messagesPathPrefix + chatRoomId
        chatDatabase.childAt(path: path).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            let result = self.dataConverter.convert(snapshot: snapshot)
            completion(result)
        }
    }
}
