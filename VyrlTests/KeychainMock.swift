//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import KeychainAccess

final class KeychainMock: KeychainProtocol {
    var accessTokenIsSet: Bool = false
    var chatTokenInSet: Bool = false
    var internalUserIdIsSet: Bool = false

    private var accessToken: String?
    private var chatToken: String?
    private var internalUserId: String?

    subscript(key: KeychainKey) -> String? {
        get {
            if key == .accessTokenUser && accessTokenIsSet {
                return accessToken
            }
            if key == .chatToken && chatTokenInSet {
                return chatToken
            }
            if key == .internalUserId && internalUserIdIsSet {
                return internalUserId
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
            if key == .internalUserId {
                internalUserIdIsSet = newValue != nil
                internalUserId = newValue
            }
        }
    }
}
