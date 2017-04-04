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

    init(text: String, mediaURL: URL) {
        self.text = text
        self.mediaURL = mediaURL
        self.isMedia = true
    }
}

extension Message: Decodable {
    static func decode(_ json: Any) throws -> Message {
        return try self.init(text: json => KeyPath(JSONKeys.text),
                             mediaURL: URL(string: json =>? OptionalKeyPath(stringLiteral: JSONKeys.mediaURL) ?? ""),
                             isMedia: json =>? OptionalKeyPath(stringLiteral: JSONKeys.isMedia) ?? false)
    }
}

extension Message: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.text: text,
                JSONKeys.isMedia: isMedia,
                JSONKeys.mediaURL: mediaURL?.absoluteString ?? ""]
    }
}

func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.text == rhs.text && lhs.mediaURL == rhs.mediaURL && lhs.isMedia == rhs.isMedia
}
