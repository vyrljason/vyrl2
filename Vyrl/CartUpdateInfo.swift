//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct CartUpdateInfo {
    fileprivate enum Keys {
        static let itemsCount = "Items.count"
    }
    let itemsCount: Int
}

extension CartUpdateInfo: DictionaryConvertible {
    var dictionaryRepresentation: [String : Any] {
        return [Keys.itemsCount: itemsCount]
    }
}

extension CartUpdateInfo: DictionaryInitializable {
    init?(dictionary: [AnyHashable : Any]?) {
        guard let itemsCount = dictionary?[Keys.itemsCount] as? Int else { return nil }
        self.itemsCount = itemsCount
    }
}
