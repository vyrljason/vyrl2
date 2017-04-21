//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ProfileControllerMock: ProfileControlling {
    var didCallSetAvatar = false
    var didCallSetBackground = false
    var didCallSetInfluencerLabel = false
    var didCallSetIndustryLabel = false
    var didCallSetBioTextView = false
    
    func setAvatar(imageFetcher: ImageFetcher) {
        didCallSetAvatar = true
    }
    
    func setBackground(imageFetcher: ImageFetcher) {
        didCallSetBackground = true
    }
    
    func setInfluencerLabel(text: String) {
        didCallSetInfluencerLabel = true
    }
    
    func setIndustryLabel(text: String) {
        didCallSetIndustryLabel = true
    }
    
    func setBioTextView(text: String) {
        didCallSetBioTextView = true
    }
}

final class ProfileInteractorTest: XCTestCase {
    
    var subject: ProfileInteractor!
    var controller: ProfileControllerMock!
    var userProfile: UserProfile!
    
    override func setUp() {
        userProfile = VyrlFaker.faker.userProfile(industries: [Industry(id: 0, name: "test")])
        controller = ProfileControllerMock()
        subject = ProfileInteractor(userProfile: userProfile)
        subject.controller = controller
    }
    
    func test_viewWillAppear_setView() {
        subject.viewWillAppear()
        
        XCTAssertTrue(controller.didCallSetAvatar)
        XCTAssertTrue(controller.didCallSetBackground)
        XCTAssertTrue(controller.didCallSetInfluencerLabel)
        XCTAssertTrue(controller.didCallSetIndustryLabel)
        XCTAssertTrue(controller.didCallSetBioTextView)
    }
}
