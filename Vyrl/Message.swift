//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Message {
    fileprivate struct JSONKeys {
        static let isMedia = "isMedia"
        static let mediaURL = "mediaUrl"
        static let text = "text"
    }
    
    let text: String
    let mediaURL: URL
    let isMedia: Bool
}

extension Message: Decodable {
    static func decode(_ json: Any) throws -> Message {
        guard let mediaURL = try URL(string: json => KeyPath(JSONKeys.mediaURL)) else {
            throw DecodingError.typeMismatch(expected: URL.self, actual: String.self, DecodingError.Metadata(object: JSONKeys.mediaURL))
        }


        return try self.init(text: json => KeyPath(JSONKeys.text),
                             mediaURL: mediaURL,
                             isMedia: json => KeyPath(JSONKeys.isMedia))
    }
}
