//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController
}

enum ProductDetailsControllerFactory: ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController {
        let interactor = ProductDetailsInteractor()
        return ProductDetailsViewController(interactor: interactor)
    }
}
