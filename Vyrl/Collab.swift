//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Collab {
    fileprivate enum JSONKeys {
        static let name = "name"
        static let author = "author"
        static let lastMessage = "lastMessage"
    }

    let brandName: String
    let authorName: String?
    let lastMessage: String
}

extension Collab: Decodable {
    static func decode(_ json: Any) throws -> Collab {
        return try self.init(brandName: json => KeyPath(JSONKeys.name),
                             authorName: json => KeyPath(JSONKeys.author),
                             lastMessage: json => KeyPath(JSONKeys.lastMessage))
    }
}
