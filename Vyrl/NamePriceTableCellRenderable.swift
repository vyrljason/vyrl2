//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct NamePriceTableCellRenderable {
    var name: String
    var price: String
    
    init(product: Product) {
        name = product.name
        price = product.retailPrice.asMoneyWithDecimals
    }
}
