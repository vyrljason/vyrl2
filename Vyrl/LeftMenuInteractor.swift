//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

@objc protocol LeftMenuInteracting: class {
    func didTapHome()
}

final class LeftMenuInteractor: LeftMenuInteracting {

    weak var delegate: HomeScreenPresenting?

    @objc func didTapHome() {
        delegate?.showHome()
    }
}
