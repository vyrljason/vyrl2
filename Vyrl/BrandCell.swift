//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BrandCell: UICollectionViewCell, HavingNib, RenderingView {
    typealias Renderable = BrandRenderable

    @IBOutlet fileprivate weak var coverImage: DownloadingImageView!
    @IBOutlet fileprivate weak var submissions: UILabel!
    @IBOutlet fileprivate weak var name: UILabel!

    static let nibName = "BrandCell"
    fileprivate let placeholder = UIImage() //TODO: replace with real placeholder

    func render(renderable: BrandRenderable) {
        name.text = renderable.name
        submissions.text = renderable.submissions
    }

    func setCoverImage(using imageFetcher: ImageFetcher) {
        coverImage.setImage(using: imageFetcher, placeholder: placeholder)
    }
}
