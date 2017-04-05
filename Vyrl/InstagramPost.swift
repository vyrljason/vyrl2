//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct InstagramPost {
    fileprivate struct JSONKeys {
        static let instagramUrl = "instagramUrl"
    }
    let postId: String
    let instagramUrl: String
}

extension InstagramPost: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.instagramUrl: instagramUrl]
    }
}
