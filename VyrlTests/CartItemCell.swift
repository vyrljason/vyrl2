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

    override func awakeFromNib() {
        super.awakeFromNib()

        image.layer.borderWidth = 1.0
        image.layer.borderColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1).cgColor
    }

    func render(_ renderable: CartItemCellRenderable) {
        title.text = renderable.title
        subTitle.text = renderable.subTitle
        price.text = renderable.price
    }

    func set(imageFetcher: ImageFetching) {
        image.fetchImage(using: imageFetcher, placeholder: Constants.placeholder)
    }
}
