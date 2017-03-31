//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ContentAdding: class {
    func didTapAddContent()
}

protocol DeliveryConfirming: class {
    func didTapConfirm()
}

enum MessagesFooterType: CustomStringConvertible {
    case addContent
    case confirmDelivery
    
    var description: String {
        switch self {
        case .addContent:
            return "Add Content"
        case .confirmDelivery:
            return "Confirm delivery"
        }
    }
    
    var image: UIImage {
        switch self {
        case .addContent:
            return #imageLiteral(resourceName: "addCircleOutline")
        case .confirmDelivery:
            return #imageLiteral(resourceName: "checkCircleOutlineBlank")
        }
    }
}

protocol MessagesFooterRendering {
    func render(renderable: MessagesFooterRenderable)
}

struct MessagesFooterRenderable {
    let footerType: MessagesFooterType
}

final class MessagesFooterView: UIView, HavingNib, MessagesFooterRendering {
    
    @IBOutlet fileprivate weak var footerButton: UIButton!
    
    static let nibName: String = "MessagesFooterView"
    fileprivate var currentRenderable: MessagesFooterRenderable?
    weak var delegate: (ContentAdding & DeliveryConfirming)?
    
    @IBAction func didTapButton() {
        guard let footerType = currentRenderable?.footerType else { return }
        switch footerType {
        case .addContent:
            delegate?.didTapAddContent()
        case .confirmDelivery:
            delegate?.didTapConfirm()
        }
    }
    
    func render(renderable: MessagesFooterRenderable) {
        currentRenderable = renderable
        footerButton.setImage(renderable.footerType.image, for: .normal)
        footerButton.setTitle(renderable.footerType.description, for: .normal)
    }
}
