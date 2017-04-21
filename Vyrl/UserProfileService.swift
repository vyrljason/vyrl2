//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UserProfileProviding {
    func get(completion: @escaping (Result<UserProfile, ServiceError>) -> Void)
}

final class UserProfileService: UserProfileProviding {
    
    private let resource: Service<UserProfileResource>
    
    init(resource: Service<UserProfileResource>) {
        self.resource = resource
    }
    
    func get(completion: @escaping (Result<UserProfile, ServiceError>) -> Void) {
        resource.get { (result) in
            completion(result.map(success: { .success($0) }, failure: { .failure($0) }))
        }
    }
}
