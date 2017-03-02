//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController
}

enum ProductDetailsControllerFactory: ProductDetailsMaking {
    static func make(product: Product) -> ProductDetailsViewController {
        let dataSource = ProductDetailsDataSource(product: product)
        let interactor = ProductDetailsInteractor(dataSource: dataSource)
        return ProductDetailsViewController(interactor: interactor)
    }
}
