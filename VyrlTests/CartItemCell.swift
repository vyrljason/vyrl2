//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct CartItemCellRenderable {
    let title: String
    let subTitle: String
    let price: String
}

protocol CartItemCellRendering {
    func render(_ renderable: CartItemCellRenderable)
}

final class CartItemCell: UICollectionViewCell, HavingNib, CartItemCellRendering {

    private enum Constants {
        static let placeholder: UIImage = #imageLiteral(resourceName: "leica")
    }

    static let nibName = "CartItemCell"

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subTitle: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var image: DownloadingImageView!

    func render(_ renderable: CartItemCellRenderable) {
        title.text = renderable.title
        subTitle.text = renderable.subTitle
        price.text = renderable.price
    }

    func set(imageFetcher: ImageFetching) {
        image.fetchImage(using: imageFetcher, placeholder: Constants.placeholder)
    }
}
