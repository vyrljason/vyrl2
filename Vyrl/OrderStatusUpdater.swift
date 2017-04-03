//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

private enum Constants {
    static let databasePathPrefix = "chats/users/"
}

protocol OrderStatusUpdatesInforming {
    func listenToOrderStatusUpdates(inRoom roomId: String, completion: @escaping (ChatRoom) -> Void)
    func stopListening(inRoom roomId: String)
}

final class OrderStatusUpdater: OrderStatusUpdatesInforming {

    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving
    private let chatCredentialsStorage: ChatCredentialsStoring
    private var observerHandler: FIRDatabaseHandle?
    private let dataConverter: SnapshotToChatRoomsConverting

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving,
         chatCredentialsStorage: ChatCredentialsStoring,
         dataConverter: SnapshotToChatRoomsConverting = ChatRoomSnapshotConverter()) {
        self.chatDatabase = chatDatabase
        self.chatCredentialsStorage = chatCredentialsStorage
        self.dataConverter = dataConverter
    }

    func listenToOrderStatusUpdates(inRoom roomId: String, completion: @escaping (ChatRoom) -> Void) {
        guard let userId = chatCredentialsStorage.internalUserId else { return }

        observerHandler = chatDatabase.childAt(path: path(for: userId, in: roomId)).observe(.childChanged) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            guard let updatedChatRoom = self.dataConverter.convert(snapshot: snapshot).values.first else { return }
            completion(updatedChatRoom)
        }
    }

    func stopListening(inRoom roomId: String) {
        guard let userId = chatCredentialsStorage.internalUserId,
        let handler = observerHandler else { return }
        chatDatabase.childAt(path: path(for: userId, in: roomId)).removeObserver(withHandle: handler)
    }

    private func path(for userId: String, in roomId: String) -> String {
        return Constants.databasePathPrefix + userId + "/" + roomId
    }
}
