//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let filterKey = "filter"
    static let whereKey = "where"
    static let brandKey = "brandId"
    static let includeKey = "include"
    static let imagesKey = "images"
}

struct ProductsRequest: DictionaryConvertible {

    let brandId: String

    init(brand: Brand) {
        self.brandId = brand.id
    }

    var dictionaryRepresentation: [String : Any] {
        return [Constants.filterKey: [Constants.includeKey: [Constants.imagesKey],
                                      Constants.whereKey: [Constants.brandKey: brandId]]]
    }
}
