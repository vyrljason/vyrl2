//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct CartItemCellRenderable {
    let title: String
    let subTitle: String
    let price: String
}

extension Product {
    var cartItemRenderable: CartItemCellRenderable {
        return CartItemCellRenderable(title: name,
                                      subTitle: description,
                                      price: retailPrice.asMoneyWithDecimals)
    }
}

protocol CartItemCellRendering {
    func render(_ renderable: CartItemCellRenderable)
}

final class CartItemCell: UITableViewCell, HavingNib, CartItemCellRendering {

    private enum Constants {
        static let placeholder: UIImage = #imageLiteral(resourceName: "photoPlaceholderSmall")
        static let borderWidth: CGFloat = 1.0
        static let borderColor: CGColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1).cgColor
    }

    static let nibName = "CartItemCell"

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subTitle: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var productImage: DownloadingImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.image = Constants.placeholder
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.cancelImageFetching(using: Constants.placeholder)
    }

    func render(_ renderable: CartItemCellRenderable) {
        title.text = renderable.title
        subTitle.text = renderable.subTitle
        price.text = renderable.price
    }

    func set(imageFetcher: ImageFetching) {
        productImage.fetchImage(using: imageFetcher, placeholder: Constants.placeholder)
    }
}
