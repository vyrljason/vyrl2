//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct CountableItemUpdate {
    fileprivate enum Keys {
        static let itemsCount = "Items.count"
    }
    let itemsCount: Int
}

extension CountableItemUpdate: DictionaryConvertible {
    var dictionaryRepresentation: [String : Any] {
        return [Keys.itemsCount: itemsCount]
    }
}

extension CountableItemUpdate: DictionaryInitializable {
    init?(dictionary: [AnyHashable : Any]?) {
        guard let itemsCount = dictionary?[Keys.itemsCount] as? Int else { return nil }
        self.itemsCount = itemsCount
    }
}
