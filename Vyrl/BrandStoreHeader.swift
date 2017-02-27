//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreHeaderRendering {
    func render(_ renderable: BrandStoreHeaderRenderable)
}

final class BrandStoreHeader: UICollectionReusableView, ReusableView, HavingNib, BrandStoreHeaderRendering {
    static let nibName = "BrandStoreHeader"
    
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var descriptionLabel: CollapsableLabel!
    @IBOutlet private weak var backgroundImage: UIImageView!
    private var dimmingLayer: CALayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognizers()
        setupDimming()
    }
    
    func render(_ renderable: BrandStoreHeaderRenderable) {
        self.header.text = renderable.title
        self.descriptionLabel.text = renderable.textCollapsed
        descriptionLabel.updateHeight()
    }

    fileprivate func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_ :)))
        descriptionLabel.addGestureRecognizer(tap)
    }
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            descriptionLabel.toggleCollapse()
        }
    }
    
    fileprivate func setupDimming() {
        let dimming = CALayer()
        dimmingLayer = dimming
        dimming.backgroundColor = UIColor.init(white: 0, alpha: 0.8).cgColor
        backgroundImage.layer.addSublayer(dimming)
    }
    
    fileprivate func resizeDimmingLayer() {
        dimmingLayer?.frame = backgroundImage.layer.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeDimmingLayer()
    }
}
