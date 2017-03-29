//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let filterKey = "filter"
    static let whereKey = "where"
    static let categoryKey = "category"
    static let idKey = "id"
    static let inqKey = "inq"
}

struct BrandsRequest: DictionaryConvertible {

    let categoryId: String?
    let brandIds: [String]?

    init(category: Category?) {
        self.categoryId = category?.id
        brandIds = nil
    }

    init(brandIds: [String]) {
        categoryId = nil
        self.brandIds = brandIds
    }

    var dictionaryRepresentation: [String : Any] {
        if let categoryId = categoryId {
            return [Constants.filterKey: [Constants.whereKey: [Constants.categoryKey: categoryId]]]
        }
        if let brandIds = brandIds {
            return [Constants.filterKey: [Constants.whereKey: [Constants.idKey: [Constants.inqKey: brandIds]]]]
        }
        return [:]
    }
}
