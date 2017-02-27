//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
@testable import Vyrl

struct MockUser: Equatable {
    let username: String
    let email: String
}

func == (lhs: MockUser, rhs: MockUser) -> Bool {
    return lhs.email == rhs.email && lhs.username == rhs.username
}

extension MockUser: Decodable {
    static func decode(_ json: Any) throws -> MockUser {
        return try self.init(username: json => "username",
                             email: json => "email")
    }
}
