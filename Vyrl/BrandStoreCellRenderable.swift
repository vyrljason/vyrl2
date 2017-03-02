//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct BrandStoreCellRenderable {
    let name: String
    let price: String
    
    init(product: Product) {
        name = product.name
        price = product.retailPrice.asMoneyWithDecimals
    }
}
