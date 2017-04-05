//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let filterKey = "filter"
    static let whereKey = "where"
    static let brandKey = "brandId"
}

struct InfluencerPostsRequest: DictionaryConvertible {

    let brandId: String

    init(brandId: String) {
        self.brandId = brandId
    }

    var dictionaryRepresentation: [String: Any] {
        return [Constants.filterKey: [Constants.whereKey: [Constants.brandKey: brandId]]]
    }
}
