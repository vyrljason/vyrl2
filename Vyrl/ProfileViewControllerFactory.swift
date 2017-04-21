//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProfileViewControllerMaking {
    static func make(userProfile: UserProfile, editProfilePresenter: EditProfilePresenting) -> ProfileViewController
}

enum ProfileViewControllerFactory: ProfileViewControllerMaking {
    static func make(userProfile: UserProfile, editProfilePresenter: EditProfilePresenting) -> ProfileViewController {
        let interactor = ProfileInteractor(userProfile: userProfile)
        interactor.editProfilePresenter = editProfilePresenter
        let profile = ProfileViewController(interactor: interactor)
        return profile
    }
}
