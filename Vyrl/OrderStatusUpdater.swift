//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Firebase

private enum Constants {
    static let databasePathPrefix = "chats/users/"
}

protocol OrderStatusUpdatesInforming {
    func listenToOrderStatusUpdates(inRoom roomId: String, completion: @escaping (OrderStatus) -> Void)
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

    func listenToOrderStatusUpdates(inRoom roomId: String,
                                    completion: @escaping (OrderStatus) -> Void) {
        guard let userId = chatCredentialsStorage.internalUserId else { return }

        observerHandler = chatDatabase.childAt(path: path(for: userId, in: roomId)).observe(.childChanged) { (snapshot) in
            guard snapshot.exists(), snapshot.key == ChatRoom.statusKey,
                let statusAsString = snapshot.value as? String else { return }
            completion(OrderStatus(description: statusAsString))
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
