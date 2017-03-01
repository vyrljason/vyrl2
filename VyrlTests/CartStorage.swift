//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol CartStoring: class {
    func add(item: CartItem)
    func remove(item: CartItem)
    var items: [CartItem] { get }
}

final class CartStorage: CartStoring {
    
    private enum Constants {
        static let defaultsKey: String = "CartStorageCartItems"
        static let accessQueueLabel: String = "SynchronizedCartStorageAccess"
    }

    private let accessQueue = DispatchQueue(label: Constants.accessQueueLabel,
                                            attributes: .concurrent)
    private var _items: [CartItem]
    private let userDefaults: ObjectStoring

    var items: [CartItem] {
        get {
            var returnValue: [CartItem]!
            accessQueue.sync {
                returnValue = self._items
            }
            return returnValue
        }

        set {
            accessQueue.async(flags: .barrier) {
                self._items = newValue.sorted(by: { $0.addedAt > $1.addedAt })
                self.userDefaults.set(self._items.map({ $0.dictionaryRepresentation }),
                                      forKey: Constants.defaultsKey)
            }
        }
    }

    init(userDefaults: ObjectStoring) {
        self.userDefaults = userDefaults

        guard let array = userDefaults.object(forKey: Constants.defaultsKey) as? [[String : Any]] else {
            _items = []
            return
        }

        _items = array.flatMap({ CartItem(from: $0) })
    }

    func add(item: CartItem) {
        items = items + [item]
    }

    func remove(item: CartItem) {
        items = items.filter({ return $0 != item })
    }
}
