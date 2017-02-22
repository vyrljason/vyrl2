//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol APICredentialsProviding {
    var userAccessToken: String? { get }
}

final class APICredentialsProvider: APICredentialsProviding {

    private let storage: CredentialsStoring

    init(storage: CredentialsStoring) {
        self.storage = storage
    }

    var userAccessToken: String? {
        return storage.accessToken
    }
}
