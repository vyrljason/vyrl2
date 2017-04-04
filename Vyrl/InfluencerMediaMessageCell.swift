//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class InfluencerMediaMessageCell: UITableViewCell, HavingNib, MessageCellRendering, ImageFetcherUsing {
    
    static let nibName = "InfluencerMediaMessageCell"
    
    @IBOutlet fileprivate weak var mediaImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var messageTextView: AutoexpandableTextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaImageView.cancelImageFetching(using: nil)
    }
    
    func render(_ renderable: MessageCellRenderable) {
        messageTextView.text = renderable.text
    }
    
    func set(imageFetcher: ImageFetching) {
        mediaImageView.fetchImage(using: imageFetcher, placeholder: #imageLiteral(resourceName: "photoPlaceholderSmall"))
    }
}
