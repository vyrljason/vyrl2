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

    private let chatDatabase: ChatDatabaseReferenceHaving
    private let chatCredentialsStorage: ChatCredentialsStoring
    private let brandsService: BrandsProviding
    private var databaseHandle: FIRDatabaseHandle = 0

    init(chatDatabase: ChatDatabaseReferenceHaving,
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

        getChatRooms(using: userId) { [weak self] chatRooms in
            guard let `self` = self else { return }

            let brandIds = chatRooms.map { $0.brandId }
            self.brandsService.getBrands(withIds: brandIds, completion: { result in
                result.on(success: { brands in
                    let collabs: [Collab] = chatRooms.flatMap { chatRoom in
                        brands.filter { $0.id == chatRoom.brandId }.first.flatMap { Collab(brandName: $0.name, chatRoom: chatRoom) }
                    }
                    completion(.success(collabs))
                }, failure: { error in
                    completion(.failure(error))
                })
            })
        }
    }

    private func getChatRooms(using userId: String, completion: @escaping ([ChatRoom]) -> Void) {
        databaseHandle = chatDatabase.reference.childAt(path: Constants.databasePathPrefix + userId).observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            var result = [ChatRoom]()
            if let roomsDictionary = snapshot.value as? [AnyHashable: [AnyHashable: Any]] {
                result = [ChatRoom](dictionaries: roomsDictionary)
            }
            completion(result)
            self.chatDatabase.reference.removeObserver(withHandle: self.databaseHandle)
        }
    }
}
