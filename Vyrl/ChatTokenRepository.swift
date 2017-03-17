//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ChatTokenProviding {
    func getChatToken(refresh: Bool, completion: @escaping (Result<ChatToken, ServiceError>) -> Void)
}

final class ChatTokenRepositoryAdapter: ChatTokenProviding {

    private let repository: StoredRepository<ChatTokenResource>

    init(repository: StoredRepository<ChatTokenResource>) {
        self.repository = repository
    }

    func getChatToken(refresh: Bool = false, completion: @escaping (Result<ChatToken, ServiceError>) -> Void) {
        repository.fetch(refresh: refresh) { result in
            completion(result.map(success: { .success(ChatToken(token: $0)) },
                                  failure: { .failure(.apiResponseError($0)) }))
        }
    }
}
