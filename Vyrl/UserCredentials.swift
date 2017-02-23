//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct UserCredentials {
    fileprivate enum JSONKeys {
        static let Username = "username"
        static let Password = "password"
    }

    let email: String
    let password: String
}

func == (lhs: UserCredentials, rhs: UserCredentials) -> Bool {
    return lhs.email == rhs.email && lhs.password == rhs.password
}

extension UserCredentials: Hashable {
    var hashValue: Int {
        return email.hashValue ^ password.hashValue
    }
}

extension UserCredentials : DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.Username: email, JSONKeys.Password: password]
    }
}
