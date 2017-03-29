//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import JWTDecode

struct InternalUserId {
    let id: String
}

private enum Constants {
    static let claimsKey = "claims"
    static let idKey = "\"id\""
}

protocol ChatTokenDecoding {
    func decodeJWT(using token: String) -> InternalUserId?
}

final class ChatTokenDecoder: ChatTokenDecoding {

    func decodeJWT(using token: String) -> InternalUserId? {
        let decodedJWT: JWT? =  try? decode(jwt: token)
        guard let claims = (decodedJWT?.body["claims"] as? [String: Int]),
        let userId: Int = claims.first?.value else {
            return nil
        }
        return InternalUserId(id: String(userId))
    }
}
