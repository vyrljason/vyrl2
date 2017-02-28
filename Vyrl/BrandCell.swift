//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandRendering {
    func render(_ renderable: BrandRenderable)
}

protocol BrandCoverImageFetching {
    func set(coverImageFetcher imageFetcher: ImageFetching)
}

final class BrandCell: UICollectionViewCell, HavingNib, BrandRendering, BrandCoverImageFetching {
    static let nibName = "BrandCell"

    @IBOutlet private weak var coverImage: DownloadingImageView!
    @IBOutlet private weak var submissions: UILabel!
    @IBOutlet private weak var submissionsCount: UILabel!
    @IBOutlet private weak var name: UILabel!

    fileprivate let placeholder = #imageLiteral(resourceName: "leica") //TODO: replace with real placeholder

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImage.cancelImageFetching()
    }

    func render(_ renderable: BrandRenderable) {
        name.text = renderable.name
        submissionsCount.text = renderable.submissions
    }

    func set(coverImageFetcher imageFetcher: ImageFetching) {
        coverImage.fetchImage(using: imageFetcher, placeholder: placeholder)
    }
}
