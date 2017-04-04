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
    
    let avatar: URL?
    let id: String
    let name: String
}

extension Sender: Decodable {
    static func decode(_ json: Any) throws -> Sender {
        let id: String
        if let idAsString: String = try? json => KeyPath(JSONKeys.id) {
            id = idAsString
        } else if let idAsNumber: Int = try? json => KeyPath(JSONKeys.id) {
            id = String(describing: idAsNumber)
        } else {
            id = ""
        }
        return try self.init(avatar: try URL(string: json => KeyPath(JSONKeys.avatar)),
                             id: id,
                             name: json => KeyPath(JSONKeys.name))
    }
}

func == (lhs: Sender, rhs: Sender) -> Bool {
    return lhs.avatar == rhs.avatar && lhs.id == rhs.id && lhs.name == rhs.name
}
