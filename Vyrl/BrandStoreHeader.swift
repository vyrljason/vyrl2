//
//  BrandStoreHeader.swift
//  Vyrl
//
//  Created by Kamil Ziętek on 21.02.2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreHeaderRendering {
    func render(_ renderable: BrandStoreHeaderRenderable)
}

final class BrandStoreHeader: UICollectionReusableView, ReusableView, HavingNib, BrandStoreHeaderRendering {
    static let nibName = "BrandStoreHeader"
    
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet private weak var backgroundImage: UIImageView!
    
    func render(_ renderable: BrandStoreHeaderRenderable) {
        self.header.text = renderable.title
        self.descriptionLabel.text = renderable.textCollapsed
    }
    
    static func registerAsHeader(to collectionView: UICollectionView?) {
        collectionView?.register(nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusableIdentifier)
    }
}
