//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension HavingNib where Self : UIView {

    // swiftlint:disable variable_name
    static func fromNib(translatesAutoresizingMaskIntoConstraints: Bool = false) -> Self {
        guard let view = nib().instantiate(withOwner: nil, options: nil).first as? Self
            else { fatalError("No nib named: \(nibName)") }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        return view
    }

    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension HavingNib where Self: ReusableView, Self: UIView {
    static func register(to collectionView: UICollectionView?) {
        collectionView?.register(nib(), forCellWithReuseIdentifier: reusableIdentifier)
    }
}

extension HavingNib where Self: UICollectionReusableView, Self: ReusableView {
    static func registerHeader(to collectionView: UICollectionView) {
        collectionView.register(nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusableIdentifier)
    }
}
