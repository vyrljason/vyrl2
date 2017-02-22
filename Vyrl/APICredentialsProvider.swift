//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol APICredentialsProviding {
    var userAccessToken: String? { get }
}

final class APICredentialsProvider: APICredentialsProviding {

    private let storage: OAuthCredentialsStoring

    init(storage: OAuthCredentialsStoring = OAuthCredentialsStorage(type: .user)) {
        self.serverStorage = serverStorage
        self.userStorage = userStorage
    }

    var userAccessToken: String? {
        return storage.accessToken
    }
}
