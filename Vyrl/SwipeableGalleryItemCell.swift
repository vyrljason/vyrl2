//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol GalleryItemFetching {
    func set(galleryImageFetcher imageFetcher: ImageFetching)
}

class SwipeableGalleryItemCell: UICollectionViewCell, HavingNib {
    static let nibName = "SwipeableGalleryItemCell"
    
    @IBOutlet private weak var galleryImage: DownloadingImageView!
    
    fileprivate let placeholder: UIImage = #imageLiteral(resourceName: "photoPlaceholderBig")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        galleryImage.cancelImageFetching(using: placeholder)
    }
    
    func set(galleryImageFetcher imageFetcher: ImageFetching) {
        galleryImage.fetchImage(using: imageFetcher, placeholder: placeholder)
    }
}
