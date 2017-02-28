//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct UserCredentials {
    fileprivate enum JSONKeys {
        static let Username = "username"
        static let Password = "password"
    }

    let username: String
    let password: String
}

func == (lhs: UserCredentials, rhs: UserCredentials) -> Bool {
    return lhs.username == rhs.username && lhs.password == rhs.password
}

extension UserCredentials: Hashable {
    var hashValue: Int {
        return username.hashValue ^ password.hashValue
    }
}

extension UserCredentials : DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.Username: username, JSONKeys.Password: password]
    }
}
