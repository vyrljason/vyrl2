//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct InstagramPost {
    fileprivate struct JSONKeys {
        static let instagramUrl = "instagramUrl"
        static let brandId = "brandId"
    }
    let brandId: String
    let instagramUrl: String
}

extension InstagramPost: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.instagramUrl: instagramUrl,
                JSONKeys.brandId: brandId]
    }
}
