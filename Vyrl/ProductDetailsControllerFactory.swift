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
        let galleryDataSource = ProductDetailsGalleryDataSource(product: product)
        let sections: [Int:SectionRenderer] = [
            ProductDetailsSections.Gallery.rawValue: GalleryRenderer(dataProvider: galleryDataSource),
            ProductDetailsSections.NameAndPrice.rawValue: NameAndPriceRenderer(),
            ProductDetailsSections.Description.rawValue: DescriptionRenderer(),
            ProductDetailsSections.Variants.rawValue: VariantsRenderer(variantHandler: variantHandler),
            ProductDetailsSections.ContentGuidelines.rawValue: ContentGuidelinesRenderer(),
            ProductDetailsSections.Cart.rawValue: AddToCartRenderer()
        ]
        let detailsDataSource = ProductDetailsDataSource(product: product, renderers: sections)
        let interactor = ProductDetailsInteractor(dataSource: detailsDataSource, variantHandler: variantHandler, product: product)
        return ProductDetailsViewController(interactor: interactor)
    }
}
