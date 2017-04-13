//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class UserProfileResourceMock: Fetching {
    
    typealias Model = UserProfile
    
    let userProfile: UserProfile = VyrlFaker.faker.userProfile()
    
    var success = true
    
    func fetch(completion: @escaping (Result<UserProfile, APIResponseError>) -> Void) {
        if success {
            completion(.success(userProfile))
        } else {
            completion(.failure(.unexpectedFailure(NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil))))
        }
    }
}
