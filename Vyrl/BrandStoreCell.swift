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
    fileprivate struct Constants {
        static let borderWidth: CGFloat = 1.0
    }
    static let nibName = "BrandStoreCell"
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var image: DownloadingImageView!
    @IBOutlet private weak var imageContainer: UIView!
    
    fileprivate let placeholder = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
        setupLabels()
    }
    
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
    
    fileprivate func setupBorder() {
        self.imageContainer.layer.borderWidth = Constants.borderWidth
        self.imageContainer.layer.borderColor = UIColor.productBorderColor.cgColor
    }
    
    fileprivate func setupLabels() {
        self.name.textColor = UIColor.productTextColor
        self.price.textColor = UIColor.productTextColor
    }
}
