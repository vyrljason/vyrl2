//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ActionDescriptionRendering {
    func render(_ renderable: ActionDescriptionRenderable)
}

struct ActionDescriptionRenderable {
    var isActionAvailable: Bool
    var description: String?
    var isDescriptionLabelVisible: Bool
}

final class ActionDescriptionView: UIView, ActionDescriptionRendering {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!

    func render(_ renderable: ActionDescriptionRenderable) {
        actionButton.alpha = renderable.isActionAvailable ? 1 : 0
        descriptionLabel.text = renderable.description
        descriptionLabel.isHidden = !renderable.isDescriptionLabelVisible
    }
}
