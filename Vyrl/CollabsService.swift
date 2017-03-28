//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum ChatServiceError: Error {
    case noUserId
}

private enum Constants {
    static let databasePathPrefix = "chats/users/"
}

protocol CollabsProviding {
    func getCollabs(completion: @escaping (Result<[Collab], ChatServiceError>) -> Void)
}

final class CollabsService: CollabsProviding {

    private let chatDatabase: ChatDatabaseReferenceHaving
    private let chatCredentialsStorage: ChatCredentialsStoring
    private var databaseHandle: FIRDatabaseHandle = 0

    init(chatDatabase: ChatDatabaseReferenceHaving, chatCredentialsStorage: ChatCredentialsStoring) {
        self.chatDatabase = chatDatabase
        self.chatCredentialsStorage = chatCredentialsStorage
    }

    func getCollabs(completion: @escaping (Result<[Collab], ChatServiceError>) -> Void) {
        guard let userId = chatCredentialsStorage.internalUserId else {
            completion(.failure(.noUserId))
            return
        }
        getChatRooms(using: userId) { result in

        }
    }

    private func getChatRooms(using userId: String, completion: @escaping (Result<[ChatRoom], ServiceError>) -> Void) {
        databaseHandle = chatDatabase.reference.childAt(path: Constants.databasePathPrefix + userId).observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let chatDictionary = snapshot.value as? [AnyHashable: Any], let chat = try? ChatRoom.decode(chatDictionary) {
                completion(.success([chat]))
            } else if let chatDictionaries = snapshot.value as? [[AnyHashable: Any]], let chats = try? [ChatRoom].decode(chatDictionaries) {
                completion(.success(chats))
            } else {
                completion(.success([]))
            }
            self.chatDatabase.reference.removeObserver(withHandle: self.databaseHandle)
        }
    }
}
