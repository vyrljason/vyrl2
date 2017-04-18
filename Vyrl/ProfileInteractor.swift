//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate enum Constants {
}

protocol ProfileInteracting {
    weak var controller: ProfileControlling? { get set }
    func viewWillAppear()
    func didTapEdit()
}

final class ProfileInteractor: ProfileInteracting {
    
    fileprivate let userProfile: UserProfile
    weak var controller: ProfileControlling?
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }
    
    func viewWillAppear() {
        setUpView()
    }
    
    func didTapEdit() {
        
    }
    
    fileprivate func setUpView() {
        setAvatar()
        setBackground()
        controller?.setInfluencerLabel(text: userProfile.username)
        setIndustry()
        controller?.setBioTextView(text: userProfile.bio)
    }
    
    fileprivate func setAvatar() {
        guard let avatarUrl = userProfile.avatar else { return }
        controller?.setAvatar(imageFetcher: ImageFetcher(url: avatarUrl))
    }
    
    fileprivate func setBackground() {
        guard let backgroundUrl = userProfile.discoveryFeedImage else { return }
        controller?.setBackground(imageFetcher: ImageFetcher(url: backgroundUrl))
    }
    
    fileprivate func setIndustry() {
        guard let industry = userProfile.industries.first else { return }
        controller?.setIndustryLabel(text: industry.name)
    }
}
