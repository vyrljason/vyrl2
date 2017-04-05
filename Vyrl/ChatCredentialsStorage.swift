//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import KeychainAccess

protocol ChatCredentialsStoring: class {
    var chatToken: String? { get set }
    var internalUserId: String? { get set }
    func clear()
}

final class ChatCredentialsStorage: ChatCredentialsStoring {

    private let keychain: KeychainProtocol

    var chatToken: String? {
        get {
            return keychain[KeychainKey.chatToken]
        }
        set {
            keychain[KeychainKey.chatToken] = newValue
        }
    }

    var internalUserId: String? {
        get {
            return keychain[KeychainKey.internalUserId]
        }
        set {
            keychain[KeychainKey.internalUserId] = newValue
        }
    }

    init(keychain: KeychainProtocol = Keychain(service: KeychainConstants.serviceName)) {
        self.keychain = keychain
    }

    func clear() {
        chatToken = nil
        internalUserId = nil
    }
}
