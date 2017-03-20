//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import KeychainAccess

final class KeychainMock: KeychainProtocol {
    var accessTokenIsSet: Bool = false
    var chatTokenInSet: Bool = false

    private var accessToken: String?
    private var chatToken: String?

    subscript(key: KeychainKey) -> String? {
        get {
            if key == .accessTokenUser && accessTokenIsSet {
                return accessToken
            }
            if key == .chatToken && chatTokenInSet {
                return chatToken
            }
            return nil
        }
        set {
            if key == .accessTokenUser {
                accessTokenIsSet = newValue != nil
                accessToken = newValue
            }
            if key == .chatToken {
                chatTokenInSet = newValue != nil
                chatToken = newValue
            }
        }
    }
}
