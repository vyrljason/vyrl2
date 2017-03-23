//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Sender {
    fileprivate struct JSONKeys {
        static let avatar = "avatar"
        static let id = "id"
        static let name = "name"
    }
    
    let avatar: URL
    let id: String
    let name: String
}

extension Sender: Decodable {
    static func decode(_ json: Any) throws -> Sender {
        guard let avatarURL = try URL(string: json => KeyPath(JSONKeys.avatar)) else {
            throw DecodingError.typeMismatch(expected: URL.self, actual: String.self, DecodingError.Metadata(object: JSONKeys.avatar))
        }

        return try self.init(avatar: avatarURL,
                             id: json => KeyPath(JSONKeys.id),
                             name: json => KeyPath(JSONKeys.name))
    }
}
