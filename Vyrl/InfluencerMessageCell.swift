//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct MessageCellRenderable {
    let text: String
}

protocol MessageCellRendering {
    func render(_ renderable: MessageCellRenderable)
}

class InfluencerMessageCell: UITableViewCell, HavingNib, MessageCellRendering {
    
    static let nibName = "InfluencerMessageCell"
    
    @IBOutlet fileprivate weak var avatarImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var messageTextView: AutoexpandableTextView!

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.cancelImageFetching(using: nil)
    }
    
    func render(_ renderable: MessageCellRenderable) {
        messageTextView.text = renderable.text
    }
    
    func set(imageFetcher: ImageFetching) {
        avatarImageView.fetchImage(using: imageFetcher, placeholder: #imageLiteral(resourceName: "photoPlaceholderSmall"))
    }
    
}
