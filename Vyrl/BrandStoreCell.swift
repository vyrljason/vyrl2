//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreCellRendering {
    func render(_ renderable: BrandStoreCellRenderable)
}

protocol BrandStoreProductImageFetching {
    func set(iconImageFetcher imageFetcher: ImageFetching)
}

final class BrandStoreCell: UICollectionViewCell, HavingNib, BrandStoreCellRendering, BrandStoreProductImageFetching {

    static let nibName = "BrandStoreCell"
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var image: DownloadingImageView!
    @IBOutlet private weak var imageContainer: UIView!
    
    fileprivate let placeholder = #imageLiteral(resourceName: "photoPlaceholderSmall")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.cancelImageFetching()
    }
    
    func render(_ renderable: BrandStoreCellRenderable) {
        self.name.text = renderable.name
        self.price.text = renderable.price
    }
    
    func set(iconImageFetcher imageFetcher: ImageFetching) {
        image.fetchImage(using: imageFetcher, placeholder: self.placeholder)
    }
}
