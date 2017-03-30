//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol DeliveryConfirming: class {
    func didTapConfirm()
}

final class ConfirmDeliveryView: UIView, HavingNib {
    
    static let nibName: String = "ConfirmDeliveryView"
    weak var delegate: DeliveryConfirming?
    
    @IBAction func didTapConfirmButton(_ sender: Any) {
        delegate?.didTapConfirm()
    }
    
}
