//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct BrandRenderable {

    let name: String
    let submissions: String

    init(brand: Brand) {
        name = brand.name
        submissions = String(brand.submissionsCount)
    }
}
