//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct ImageMessage {
    fileprivate struct JSONKeys {
        static let mediaUrl = "mediaUrl"
        static let brandId = "brandId"
        static let description = "description"
    }

    let description: String
    let brandId: String
    let mediaUrl: URL
}

extension ImageMessage: DictionaryConvertible {

    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.mediaUrl: mediaUrl.absoluteString,
                JSONKeys.brandId: brandId,
                JSONKeys.description: description]
    }
}
