//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct ContactInfo {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let email = "email"
        static let phone = "phone"
    }

    let id: String
    let email: String
    let phone: String
}

extension ContactInfo: Decodable {
    static func decode(_ json: Any) throws -> ContactInfo {
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             email: json => KeyPath(JSONKeys.email),
                             phone: json => KeyPath(JSONKeys.phone))
    }
}

extension ContactInfo: DictionaryConvertible {
    var dictionaryRepresentation: [String : Any] {
        return [JSONKeys.email: email,
                JSONKeys.phone: phone]
    }
}
