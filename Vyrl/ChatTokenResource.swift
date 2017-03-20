//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class ChatTokenResource: RepositorySource, APIResource {

    typealias ResponseType = ChatToken
    let storageKey: KeychainKey = .chatToken
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func fetch(completion: @escaping (Result<ChatToken, APIResponseError>) -> Void) {
        controller.call(endpoint: ChatTokenEndpoint(), completion: completion)
    }
}
