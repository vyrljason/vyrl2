//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
@testable import Vyrl

final class LeftMenuInteractingMock: LeftMenuInteracting {

    var collectionView: UICollectionView?
    var didTapHomeCalled = false
    var didTapAccountCalled = false

    func didTapHome() {
        didTapHomeCalled = true
    }

    func didTapAccount() {
        didTapAccountCalled = true
    }

    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
}
