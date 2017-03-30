//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import FirebaseDatabase

private enum Constants {
    static let databasePathPrefix = "chats/users/"
}

protocol CollabsProviding {
    func getCollabs(completion: @escaping (Result<[Collab], ServiceError>) -> Void)
}

final class CollabsService: CollabsProviding {

    private let chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving
    private let chatCredentialsStorage: ChatCredentialsStoring
    private let brandsService: BrandsProviding
    private var databaseHandle: FIRDatabaseHandle = 0

    init(chatDatabase: ChatDatabaseChildAccessing & ChatDatabaseObserving,
         chatCredentialsStorage: ChatCredentialsStoring,
         brandsService: BrandsProviding) {
        self.chatDatabase = chatDatabase
        self.chatCredentialsStorage = chatCredentialsStorage
        self.brandsService = brandsService
    }

    func getCollabs(completion: @escaping (Result<[Collab], ServiceError>) -> Void) {
        guard let userId = chatCredentialsStorage.internalUserId else {
            completion(.failure(.unknown))
            return
        }

        getChatRoomsWithIds(using: userId) { [weak self] chatRoomsWithIds in
            guard let `self` = self else { return }
            let brandIds: [String] = chatRoomsWithIds.values.map { $0.brandId }
            self.brandsService.getBrands(withIds: brandIds, completion: { result in
                result.on(success: { brands in
                    let collabs: [Collab] = chatRoomsWithIds.flatMap { (chatRoomId, chatRoom) in
                        brands.filter { $0.id == chatRoom.brandId }.first.flatMap { Collab(chatRoomId: chatRoomId, brandName: $0.name, chatRoom: chatRoom) }
                    }
                    completion(.success(collabs))
                }, failure: { error in
                    completion(.failure(error))
                })
            })
        }
    }

    private func getChatRoomsWithIds(using userId: String, completion: @escaping ([String: ChatRoom]) -> Void) {
        databaseHandle = chatDatabase.childAt(path: Constants.databasePathPrefix + userId).observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            var result = [String: ChatRoom]()
            if let roomsDictionary = snapshot.value as? [AnyHashable: [AnyHashable: Any]] {
                roomsDictionary.forEach({ (key, valueDictionary) in
                    if let room = ChatRoom(dictionary: valueDictionary), let roomId = key as? String {
                        result[roomId] = room
                    }
                })
            }
            self.chatDatabase.removeObserver(withHandle: self.databaseHandle)
            completion(result)
        }
    }
}
