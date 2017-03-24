//
//  MainStatusView.swift
//  Vyrl
//
//  Created by Wojciech Stasiński on 24/03/2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct MainStatusViewRenderable {
    let status: NSAttributedString
    let isExpanded: Bool
    let arrowHidden: Bool
}

final class MainStatusView: UIView, HavingNib {
    
    static let nibName: String = "MainStatusView"
    
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet weak var arrowImageview: UIImageView!
    
    func render(renderable: MainStatusViewRenderable) {
        statusLabel.attributedText = renderable.status
        arrowImageview.image = renderable.isExpanded ? #imageLiteral(resourceName: "icoChevronUpWhite") : #imageLiteral(resourceName: "icoChevronDownWhite")
        arrowImageview.isHidden = renderable.arrowHidden
    }
    
}
