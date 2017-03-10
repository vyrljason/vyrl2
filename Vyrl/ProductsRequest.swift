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
    static let idKey = "id"
    static let inqKey = "inq"
}

struct ProductsRequest: DictionaryConvertible {

    let brandId: String?
    let productIds: [String]?

    init(brand: Brand) {
        self.brandId = brand.id
        productIds = nil
    }

    init(productIds: [String]) {
        self.productIds = productIds
        self.brandId = nil
    }

    var dictionaryRepresentation: [String: Any] {
        if let brandId = brandId {
            return [Constants.filterKey: [Constants.includeKey: [Constants.imagesKey],
                                          Constants.whereKey: [Constants.brandKey: brandId]]]
        }
        if let productIds = productIds {
            return [Constants.filterKey: [Constants.includeKey: [Constants.imagesKey],
                                          Constants.whereKey: [Constants.idKey: [Constants.inqKey: productIds]]]]
        }
        return [:]
    }
}
