//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandRendering {
    func render(_ renderable: BrandRenderable)
}

protocol BrandCoverImageFetching {
    func setCoverImage(using imageFetcher: ImageFetching)
}

final class BrandCell: UICollectionViewCell, HavingNib, BrandRendering, BrandCoverImageFetching {
    typealias Renderable = BrandRenderable

    @IBOutlet private weak var coverImage: DownloadingImageView!
    @IBOutlet private weak var submissions: UILabel!
    @IBOutlet private weak var name: UILabel!

    static let nibName = "BrandCell"
    fileprivate let placeholder = UIImage() //TODO: replace with real placeholder

    func render(_ renderable: BrandRenderable) {
        name.text = renderable.name
        submissions.text = renderable.submissions
    }

    func setCoverImage(using imageFetcher: ImageFetching) {
        coverImage.fetchImage(using: imageFetcher, placeholder: placeholder)
    }
}
