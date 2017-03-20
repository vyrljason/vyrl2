//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import KeychainAccess

protocol ChatTokenStoring: class {
    var chatToken: String? { get set }
}

final class ChatTokenStorage: ChatTokenStoring {

    private var keychain: KeychainProtocol

    var chatToken: String? {
        get {
            return keychain[KeychainKey.chatToken]
        }
        set {
            keychain[KeychainKey.chatToken] = newValue
        }
    }

    init(keychain: KeychainProtocol = Keychain(service: KeychainConstants.serviceName)) {
        self.keychain = keychain
    }
}
