//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsMaking {
    static func make(brand: Product) -> ProductDetailsViewController
}

enum ProductDetailsControllerFactory: ProductDetailsMaking {
    static func make(brand: Product) -> ProductDetailsViewController {
        return ProductDetailsViewController()
    }
}
