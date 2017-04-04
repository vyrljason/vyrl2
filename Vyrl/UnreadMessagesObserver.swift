//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import FirebaseDatabase

private enum Constants {
    static let databasePathPrefix = "chats/users/"
}

let unreadMessagesUpdateNotificationName = Notification.Name("io.govyrl.vyrl.ios.main.brand.dev.unreadMessagesUpdated")

protocol UnreadMessagesObserving {
    func observeUnreadMessages()
    func stopObserving()
}

final class UnreadMessagesObserver: UnreadMessagesObserving {
    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving
    private let chatCredentialsStorage: ChatCredentialsStoring
    private let dataConverter: SnapshotToChatRoomsConverting
    private let notificationSender: NotificationPosting

    private var chatRooms = [String: ChatRoom]()
    private var unreadMessages: Int {
        return chatRooms.values.map { $0.unreadMessages }.reduce(0, { $0 + $1 })
    }

    private var childAddedHandler: FIRDatabaseHandle?
    private var childChangedHandler: FIRDatabaseHandle?

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving,
         chatCredentialsStorage: ChatCredentialsStoring,
         dataConverter: SnapshotToChatRoomsConverting = ChatRoomsSnapshotConverter(),
         notificationSender: NotificationPosting = NotificationCenter.default) {
        self.chatDatabase = chatDatabase
        self.chatCredentialsStorage = chatCredentialsStorage
        self.dataConverter = dataConverter
        self.notificationSender = notificationSender
    }

    func observeUnreadMessages() {
        guard let userId = chatCredentialsStorage.internalUserId else { return }
        let snapshotCallback: (FIRDataSnapshot) -> Void = { [weak self]  (snapshot) in
            guard let `self` = self else { return }
            let result = self.dataConverter.convert(snapshot: snapshot)
            self.chatRooms += result
            self.postUpdate()
        }
        childChangedHandler = chatDatabase.childAt(path: path(for: userId)).observe(.childChanged, with: snapshotCallback)
        childAddedHandler = chatDatabase.childAt(path: path(for: userId)).observe(.childAdded, with: snapshotCallback)
    }

    private func postUpdate() {
        let update = CountableItemUpdate(itemsCount: unreadMessages)
        notificationSender.post(name: Notification(name: unreadMessagesUpdateNotificationName).name,
                                object: nil,
                                userInfo: update.dictionaryRepresentation)
    }

    func stopObserving() {
        guard let userId = chatCredentialsStorage.internalUserId else { return }
        if let childAddedHandler = childAddedHandler {
            chatDatabase.childAt(path: path(for: path(for: userId))).removeObserver(withHandle: childAddedHandler)
        }
        if let childChangedHandler = childChangedHandler {
            chatDatabase.childAt(path: path(for: path(for: userId))).removeObserver(withHandle: childChangedHandler)
        }
    }

    private func path(for userId: String) -> String {
        return Constants.databasePathPrefix + userId
    }
}
