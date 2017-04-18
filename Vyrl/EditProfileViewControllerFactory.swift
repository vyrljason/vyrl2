//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol EditProfileViewControllerMaking {
    static func make(userProfile: UserProfile) -> EditProfileViewController
}

enum EditProfileViewControllerFactory: EditProfileViewControllerMaking {
    static func make(userProfile: UserProfile) -> EditProfileViewController {
        let interactor = EditProfileInteractor(userProfile: userProfile)
        let editProfile = EditProfileViewController(interactor: interactor)
        return editProfile
    }
}
