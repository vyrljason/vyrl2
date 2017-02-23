//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AccountViewControllerMaking {
    static func make() -> AccountViewController
}

enum AccountViewControllerFactory: AccountViewControllerMaking {
    static func make() -> AccountViewController {
        let account = AccountViewController()
        account.title = "ACCOUNT" // FIXME: remove
        account.view.backgroundColor = .white // FIXME: remove
        return account
    }
}
