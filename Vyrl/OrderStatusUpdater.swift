//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

private enum Constants {
    static let databasePathPrefix = "chats/users/"
}

protocol OrderStatusUpdatesInforming {
    func listenToStatusUpdates(inRoom roomId: String, completion: @escaping (OrderStatus?, ContentStatus?) -> Void)
    func stopListening(inRoom roomId: String)
}

final class OrderStatusUpdater: OrderStatusUpdatesInforming {

    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving
    private let chatCredentialsStorage: ChatCredentialsStoring
    private var observerHandler: FIRDatabaseHandle?

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving,
         chatCredentialsStorage: ChatCredentialsStoring) {
        self.chatDatabase = chatDatabase
        self.chatCredentialsStorage = chatCredentialsStorage
    }

    func listenToStatusUpdates(inRoom roomId: String,
                                    completion: @escaping (OrderStatus?, ContentStatus?) -> Void) {
        guard let userId = chatCredentialsStorage.internalUserId else { return }

        observerHandler = chatDatabase.childAt(path: path(for: userId, in: roomId)).observe(.childChanged) { (snapshot) in
            guard snapshot.exists() else { return }
            if snapshot.key == ChatRoom.orderStatusKey,
                let statusAsString = snapshot.value as? String {
            completion(OrderStatus(description: statusAsString), nil)

            }
            if snapshot.key == ChatRoom.contentStatusKey,
                let statusAsString = snapshot.value as? String {
                completion(nil, ContentStatus(description: statusAsString))
            }
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
