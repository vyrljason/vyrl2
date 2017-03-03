//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController
}

enum ProductDetailsControllerFactory: ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController {
        let variantHandler = VariantHandler(allVariants: product.variants)
        let sections: [Int:SectionRenderer] = [
            ProductDetailsSections.NameAndPrice.rawValue: NameAndPriceRenderer(),
            ProductDetailsSections.Variants.rawValue: VariantsRenderer(variantHandler: variantHandler),
            ProductDetailsSections.Cart.rawValue: AddToCartRenderer()
        ]
        let dataSource = ProductDetailsDataSource(product: product, renderers: sections)
        let interactor = ProductDetailsInteractor(dataSource: dataSource, variantHandler: variantHandler, product: product)
        return ProductDetailsViewController(interactor: interactor)
    }
}
