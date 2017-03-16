//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CollabsRendering {
    func render(_ renderable: CollabRenderable)
}

final class CollabCell: UICollectionViewCell, HavingNib, CollabsRendering {
    static let nibName = "CollabCell"

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var lastMessage: UILabel!

    override func awakeFromNib() {

    }
    func render(_ renderable: CollabRenderable) {
        name.text = renderable.name
        lastMessage.text = renderable.lastMessage
    }
}
