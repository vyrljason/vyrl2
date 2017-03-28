//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Messages {
    let messages: [MessageContainer]
}

extension Messages: Decodable {
    static func decode(_ json: Any) throws -> Messages {
        return try self.init(messages: [MessageContainer].decode(json))
    }
}
