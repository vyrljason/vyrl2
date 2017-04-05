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

protocol InstagramLinkAdding: class {
    func didTapAddLink()
}

enum MessagesFooterType: CustomStringConvertible {
    case addContent
    case confirmDelivery
    case instagramLink
    
    var description: String {
        switch self {
        case .addContent:
            return "Add Content"
        case .confirmDelivery:
            return "Confirm delivery"
        case .instagramLink:
            return "Tap here to paste link to published post"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .addContent:
            return #imageLiteral(resourceName: "addCircleOutline")
        case .confirmDelivery:
            return #imageLiteral(resourceName: "checkCircleOutlineBlank")
        case .instagramLink:
            return nil
        }
    }
    
    var imageEdgeInsets: UIEdgeInsets {
        switch self {
        case .instagramLink:
            return .zero
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        
        }
    }
    
    var titleEdgeInsets: UIEdgeInsets {
        switch self {
        case .instagramLink:
            return .zero
        default:
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
        }
    }
    
    var fontColor: UIColor {
        switch self {
        case .instagramLink:
            return UIColor.white.withAlphaComponent(0.5)
        default:
            return .white
        }
    }
    
    var font: UIFont {
        switch self {
        case .instagramLink:
            return .systemFont(ofSize: 16)
        default:
            return .systemFont(ofSize: 18)
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
    weak var delegate: (ContentAdding & DeliveryConfirming & InstagramLinkAdding)?
    
    @IBAction func didTapButton() {
        guard let footerType = currentRenderable?.footerType else { return }
        switch footerType {
        case .addContent:
            delegate?.didTapAddContent()
        case .confirmDelivery:
            delegate?.didTapConfirm()
        case .instagramLink:
            delegate?.didTapAddLink()
        }
    }
    
    func render(renderable: MessagesFooterRenderable) {
        currentRenderable = renderable
        footerButton.setImage(renderable.footerType.image, for: .normal)
        footerButton.setTitle(renderable.footerType.description, for: .normal)
        footerButton.setTitleColor(renderable.footerType.fontColor, for: .normal)
        footerButton.titleLabel?.font = renderable.footerType.font
    }
}
