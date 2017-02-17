//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Strings {
    static let submissionsName = NSLocalizedString("brand.submissionName", comment: "")
}

protocol BrandRendering {
    func render(_ renderable: BrandRenderable)
}

protocol BrandCoverImageFetching {
    func setCoverImage(using imageFetcher: ImageFetching)
}

final class BrandCell: UICollectionViewCell, HavingNib, BrandRendering, BrandCoverImageFetching {
    static let nibName = "BrandCell"

    @IBOutlet private weak var coverImage: DownloadingImageView!
    @IBOutlet private weak var submissions: UILabel!
    @IBOutlet private weak var submissionsCount: UILabel!
    @IBOutlet private weak var name: UILabel!

    fileprivate let placeholder = UIImage() //TODO: replace with real placeholder

    override func awakeFromNib() {
        super.awakeFromNib()
        submissions.text = Strings.submissionsName
    }

    func render(_ renderable: BrandRenderable) {
        name.text = renderable.name
        submissionsCount.text = renderable.submissions
    }

    func setCoverImage(using imageFetcher: ImageFetching) {
        coverImage.fetchImage(using: imageFetcher, placeholder: placeholder)
    }
}
