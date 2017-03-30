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
    let mediaURL: URL?
    let isMedia: Bool

    init(text: String, mediaURL: URL? = nil, isMedia: Bool = false) {
        self.text = text
        self.mediaURL = mediaURL
        self.isMedia = isMedia
    }
}

extension Message: Decodable {
    static func decode(_ json: Any) throws -> Message {
        return try self.init(text: json => KeyPath(JSONKeys.text),
                             mediaURL: URL(string: json => KeyPath(JSONKeys.mediaURL)),
                             isMedia: json => KeyPath(JSONKeys.isMedia))
    }
}

extension Message: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.text: text,
                JSONKeys.isMedia: isMedia,
                JSONKeys.mediaURL: mediaURL?.absoluteString ?? ""]
    }
}
