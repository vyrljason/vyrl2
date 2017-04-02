//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct EmptyResponse: Decodable {
    static func decode(_ json: Any) throws -> EmptyResponse {
        return EmptyResponse()
    }
}
