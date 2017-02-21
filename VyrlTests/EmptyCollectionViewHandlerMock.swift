//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class EmptyCollectionViewHandlerMock: EmptyCollectionViewHandling {
    var currentMode: EmptyCollectionMode?
    var useDidCall = false

    func configure(with mode: EmptyCollectionMode) {
        currentMode = mode
    }

    func use(_ collectionView: UICollectionView) {
        useDidCall = true
    }
}
