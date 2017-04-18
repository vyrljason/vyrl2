//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate enum Constants {
}

protocol EditProfileInteracting {
    weak var controller: EditProfileControlling? { get set }
    func viewWillAppear()
}

final class EditProfileInteractor: EditProfileInteracting {
    
    fileprivate let userProfile: UserProfile
    weak var controller: EditProfileControlling?
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }
    
    func viewWillAppear() {
    }
}
