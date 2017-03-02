//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let filterKey = "filter"
    static let whereKey = "where"
    static let categoryKey = "category"
}

struct BrandsRequest: DictionaryConvertible {

    let categoryId: String?

    init(category: Category?) {
        self.categoryId = category?.id
    }

    var dictionaryRepresentation: [String : Any] {
        guard let categoryId = categoryId else { return [:] }
        return [Constants.filterKey: [Constants.whereKey: [Constants.categoryKey: categoryId]]]
    }
}
