//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Brand {
    fileprivate struct JSONKeys {
        static let name = "name"
        static let submissionsCount = "submissionsCount"
        static let coverImageURL = "coverImageUrl"
    }

    let name: String
    let submissionsCount: Int
    let coverImageURL: URL
}

extension Brand: Decodable {
    static func decode(_ json: Any) throws -> Brand {
        guard let coverImageURL = try URL(string: json => KeyPath(JSONKeys.coverImageURL)) else {
            throw DecodingError.typeMismatch(expected: URL.self, actual: String.self, DecodingError.Metadata(object: JSONKeys.coverImageURL))
        }
        return try self.init(name: json => KeyPath(JSONKeys.name),
                             submissionsCount: json => KeyPath(JSONKeys.submissionsCount),
                             coverImageURL: coverImageURL)
    }
}
