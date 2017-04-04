//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let databasePathPrefix = "chats/users/"
    static let unreadKey = "unread"
}

protocol ChatPresenceInforming {
    func userDidEnter(chatRoom roomId: String)
    func userWillLeave(chatRoom roomId: String)
}

final class ChatPresenceService: ChatPresenceInforming {

    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseUpdating
    private let chatCredentialsStorage: ChatCredentialsStoring

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseUpdating,
         chatCredentialsStorage: ChatCredentialsStoring) {
        self.chatDatabase = chatDatabase
        self.chatCredentialsStorage = chatCredentialsStorage
    }

    func userDidEnter(chatRoom roomId: String) {
        guard let userId = chatCredentialsStorage.internalUserId else { return }
        resetUnreadCount(chatRoom: roomId, forUser: userId)
    }

    func userWillLeave(chatRoom roomId: String) {
        guard let userId = chatCredentialsStorage.internalUserId else { return }
        resetUnreadCount(chatRoom: roomId, forUser: userId)
    }

    private func path(for userId: String, in roomId: String) -> String {
        return Constants.databasePathPrefix + userId + "/" + roomId + "/" + Constants.unreadKey
    }

    private func resetUnreadCount(chatRoom roomId: String, forUser userId: String) {
        chatDatabase.childAt(path: path(for: userId, in: roomId)).setValue(0)
    }
}
