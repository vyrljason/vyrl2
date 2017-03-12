//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
@testable import Vyrl

final class CartStoringMock: CartStoring {
    var items: [CartItem] = []

    var didCallClear = false

    func add(item: CartItem) {
        items.append(item)
    }

    func remove(item: CartItem) {
        items = items.filter({ $0.productId != item.productId })
    }

    func clear() {
        didCallClear = true
        items = []
    }
}
