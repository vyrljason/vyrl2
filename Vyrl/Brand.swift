//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Brand {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let name = "name"
        static let description = "description"
        static let submissionsCount = "submissions"
        static let coverImageURL = "cover"
    }

    let id: String
    let name: String
    let description: String
    let submissionsCount: Int
    let coverImageURL: URL?
}

extension Brand: Decodable {
    static func decode(_ json: Any) throws -> Brand {
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             name: json => KeyPath(JSONKeys.name),
                             description: json => KeyPath(JSONKeys.description),
                             submissionsCount: json =>? OptionalKeyPath(stringLiteral: JSONKeys.submissionsCount) ?? 0,
                             coverImageURL: URL(string: json => KeyPath(JSONKeys.coverImageURL)))
    }
}
