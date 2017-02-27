//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreHeaderRendering {
    func render(_ renderable: BrandStoreHeaderRenderable)
}

protocol BrandStoreHeaderDelegate: class {
    func headerDidChangeHeight(height: CGFloat)
}

final class BrandStoreHeader: UICollectionReusableView, ReusableView, HavingNib, BrandStoreHeaderRendering {
    static let nibName = "BrandStoreHeader"
    
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var descriptionLabel: ExpandableTextView!
    @IBOutlet private weak var backgroundImage: UIImageView!
    weak var delegate: BrandStoreHeaderDelegate?
    private var dimmingLayer: CALayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognizers()
        setupDimming()
        setupDescriptionLabel()
    }
    
    fileprivate func setupDimming() {
        let dimming = CALayer()
        dimmingLayer = dimming
        dimming.backgroundColor = UIColor.init(white: 0, alpha: 0.8).cgColor
        backgroundImage.layer.addSublayer(dimming)
    }
    
    fileprivate func setupDescriptionLabel() {
        self.descriptionLabel.isScrollEnabled = false
        self.descriptionLabel.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func render(_ renderable: BrandStoreHeaderRenderable) {
        self.header.text = renderable.title
        self.descriptionLabel.text = renderable.textCollapsed + renderable.textCollapsed + renderable.textCollapsed
    }

    fileprivate func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_ :)))
        descriptionLabel.addGestureRecognizer(tap)
    }
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            descriptionLabel.toggleExpand()
            notifyAboutHeightChange()
        }
    }
    
    fileprivate func notifyAboutHeightChange() {
        let totalHeight: CGFloat = 71 + 37 + self.descriptionLabel.targetHeight()
        delegate?.headerDidChangeHeight(height: totalHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeDimmingLayer()
    }
    
    fileprivate func resizeDimmingLayer() {
        dimmingLayer?.frame = backgroundImage.layer.bounds
    }
}
