//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProfileViewControllerMaking {
    static func make(userProfile: UserProfile) -> ProfileViewController
}

enum ProfileViewControllerFactory: ProfileViewControllerMaking {
    static func make(userProfile: UserProfile) -> ProfileViewController {
        let interactor = ProfileInteractor(userProfile: userProfile)
        let profile = ProfileViewController(interactor: interactor)
        return profile
    }
}
