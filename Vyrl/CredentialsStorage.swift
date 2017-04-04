//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import KeychainAccess

protocol CredentialsStoring: class {
    var accessToken: String? { get set }
}

final class CredentialsStorage: CredentialsStoring {

    private let keychain: KeychainProtocol

    var accessToken: String? {
        get {
            return keychain[KeychainKey.accessTokenUser]
        }
        set {
            keychain[KeychainKey.accessTokenUser] = newValue
        }
    }

    init(keychain: KeychainProtocol = Keychain(service: KeychainConstants.serviceName)) {
        self.keychain = keychain
    }
}

extension CredentialsStoring {
    func saveToken(using userProfile: UserProfile) {
        accessToken = userProfile.token
    }
}
