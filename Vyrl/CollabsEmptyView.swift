//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let headerText = NSLocalizedString("Hey", comment: "")
    static let descriptionText = NSLocalizedString("You don't have any active collaborations yet. Hit \"close\" at the top of the screen to start looking through brands to work with.", comment: "")
}

final class CollabsEmptyView: UIView, HavingNib {
    static let nibName: String = "CollabsEmptyView"
    
    @IBOutlet private weak var headerLeabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerLeabel.text = Constants.headerText
        descriptionLabel.text = Constants.descriptionText
    }
}
