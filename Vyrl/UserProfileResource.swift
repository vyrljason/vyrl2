//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class UserProfileResource: Fetching, APIResource {
    
    typealias Model = UserProfile
    
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func fetch(completion: @escaping (Result<UserProfile, APIResponseError>) -> Void) {
        controller.call(endpoint: UserProfileEndpoint(), completion: completion)
    }
}
