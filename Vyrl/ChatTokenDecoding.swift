//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import JWTDecode

struct InternalUserId {
    let id: String
}

private enum Constants {
    static let internalUserIdClaim = "id"
}

protocol ChatTokenDecoding {
    func decodeJWT(using token: String) -> InternalUserId?
}

final class ChatTokenDecoder: ChatTokenDecoding {

    func decodeJWT(using token: String) -> InternalUserId? {
        let decodedJWT: JWT? =  try? decode(jwt: token)
        guard let userIdClaim = decodedJWT?.claim(name: Constants.internalUserIdClaim).string else {
            return nil
        }
        return InternalUserId(id: userIdClaim)
    }
}
