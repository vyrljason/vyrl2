//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ContentAdding: class {
    func didTapAddContent()
}

final class AddContentView: UIView, HavingNib {
    
    static let nibName: String = "AddContentView"
    weak var delegate: ContentAdding?
    
    @IBAction func didTapAddContentButton(_ sender: Any) {
        delegate?.didTapAddContent()
    }
    
}
