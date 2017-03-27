//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import KeychainAccess

enum KeychainKey: String, CustomStringConvertible {
    case accessTokenUser = "vyrl-app-access-token-user"
    case chatToken = "vyrl-app-chat-token"
    case internalUserId = "vyrl-app-internal-user-id"

    var description: String {
        return self.rawValue
    }
}

protocol KeychainProtocol: class {
    subscript(key: KeychainKey) -> String? { get set }
}

extension Keychain: KeychainProtocol {
    internal subscript(key: KeychainKey) -> String? {
        get {
            return self[String(describing: key)]
        }

        set {
            self[String(describing: key)] = newValue
        }
    }
}
