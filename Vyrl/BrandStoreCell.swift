//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreCellRendering {
    func render(_ renderable: BrandStoreCellRenderable)
}

final class BrandStoreCell: UICollectionViewCell, HavingNib, BrandStoreCellRendering {
    fileprivate struct Constants {
        static let borderWidth: CGFloat = 1.0
    }
    static let nibName = "BrandStoreCell"
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var imageContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    func render(_ renderable: BrandStoreCellRenderable) {
        self.name.text = renderable.name
        self.price.text = renderable.price
    }
    
    fileprivate func setupBorder() {
        self.imageContainer.layer.borderWidth = Constants.borderWidth
        self.imageContainer.layer.borderColor = UIColor.productBorderColor.cgColor
    }
}
