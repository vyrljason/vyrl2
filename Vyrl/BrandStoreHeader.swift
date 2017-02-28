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

protocol BrandStoreHeaderImageFetching {
    func set(coverImageFetcher imageFetcher: ImageFetching)
}

final class BrandStoreHeader: UICollectionReusableView, ReusableView, HavingNib, BrandStoreHeaderRendering, BrandStoreHeaderImageFetching {
    static let nibName = "BrandStoreHeader"
    
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var descriptionLabel: ExpandableTextView!
    @IBOutlet private weak var backgroundImage: DownloadingImageView!
    @IBOutlet private weak var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionBottomConstraint: NSLayoutConstraint!
    weak var delegate: BrandStoreHeaderDelegate?
    private var dimmingLayer: CALayer?
    fileprivate let placeholder = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognizers()
        setupDimming()
        setupDescriptionLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.cancelImageFetching()
    }
    
    fileprivate func setupDimming() {
        let dimming = CALayer()
        dimmingLayer = dimming
        dimming.backgroundColor = UIColor.dimmingBlack.cgColor
        backgroundImage.layer.addSublayer(dimming)
    }
    
    fileprivate func setupDescriptionLabel() {
        descriptionLabel.isScrollEnabled = false
        descriptionLabel.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func render(_ renderable: BrandStoreHeaderRenderable) {
        header.text = renderable.title
        descriptionLabel.text = renderable.textCollapsed
    }
    
    func set(coverImageFetcher imageFetcher: ImageFetching) {
        backgroundImage.fetchImage(using: imageFetcher, placeholder: placeholder)
    }

    fileprivate func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_ :)))
        descriptionLabel.addGestureRecognizer(tap)
    }
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            descriptionLabel.toggleExpand()
            notifyAboutHeightChange()
        }
    }
    
    fileprivate func notifyAboutHeightChange() {
        let verticalSpace: CGFloat = descriptionTopConstraint.constant + descriptionBottomConstraint.constant
        let totalHeight: CGFloat = verticalSpace + descriptionLabel.targetHeight()
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
