//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct BrandStoreHeaderRenderable {
    let title: String
    let textCollapsed: String
    var textExpanded: String?
    
    init(brand: Brand) {
        self.title = brand.name
        self.textCollapsed = brand.description
    }
}
