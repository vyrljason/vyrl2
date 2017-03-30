//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

private enum Constants {
    static let databasePathPrefix = "chats/messages/"
}

protocol MessagesProviding {
    func getMessages(inChatRoom chatRoomId: String, completion: @escaping (Result<[MessageContainer], ServiceError>) -> Void)
}

final class MessagesService: MessagesProviding {

    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving
    private var databaseHandle: FIRDatabaseHandle = 0

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving) {
        self.chatDatabase = chatDatabase
    }

    func getMessages(inChatRoom chatRoomId: String, completion: @escaping (Result<[MessageContainer], ServiceError>) -> Void) {
        getMessagesData(inChatRoom: chatRoomId) { (messagesWithIds) in
            completion(.success(Array(messagesWithIds.values)))
        }
    }

    private func getMessagesData(inChatRoom chatRoomId: String, completion: @escaping ([String: MessageContainer]) -> Void) {
        databaseHandle = chatDatabase.childAt(path: Constants.databasePathPrefix + chatRoomId).observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            var result = [String: MessageContainer]()
            if let roomsDictionary = snapshot.value as? [AnyHashable: [AnyHashable: Any]] {
                roomsDictionary.forEach({ (key, valueDictionary) in
                    if let room = try? MessageContainer.decode(valueDictionary), let roomId = key as? String {
                        result[roomId] = room
                    }
                })
            }
            completion(result)
            self.chatDatabase.removeObserver(withHandle: self.databaseHandle)
        }
    }
}
