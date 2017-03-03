//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController
}

enum ProductDetailsControllerFactory: ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController {
        let sections: [Int:SectionRenderer] = [
            ProductDetailsSections.NameAndPrice.rawValue: NameAndPriceRenderer(),
            ProductDetailsSections.Cart.rawValue: AddToCartRenderer()
        ]
        let dataSource = ProductDetailsDataSource(product: product, renderers: sections)
        let interactor = ProductDetailsInteractor(dataSource: dataSource)
        return ProductDetailsViewController(interactor: interactor)
    }
}
