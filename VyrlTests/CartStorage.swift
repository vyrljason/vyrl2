//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct CartItem {
    let id: String
    let addedAt: Date
}

protocol CartStoraging: class {
    func add(item: CartItem)
    func remove(item: CartItem)
    var items: [CartItem] { get }
}

final class CartStorage: CartStoraging {

    var items: [CartItem] = []

    func add(item: CartItem) {
        items.append(item)
    }

    func remove(item: CartItem) {
        items = items.filter({ return $0.id != item.id })
    }
}
