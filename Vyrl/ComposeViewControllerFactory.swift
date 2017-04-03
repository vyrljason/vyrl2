//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ComposeControllerMaking {
    static func make(closer: ComposeClosing) -> ComposeViewController
}

enum ComposeViewControllerFactory: ComposeControllerMaking {
    static func make(closer: ComposeClosing) -> ComposeViewController {
        let interactor = ComposeInteractor()
        interactor.composeCloser = closer
        return ComposeViewController(interactor: interactor)
    }
}
