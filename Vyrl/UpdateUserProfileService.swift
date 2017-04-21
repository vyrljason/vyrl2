//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol PartUserProfileUpdating {
    func update(updatedUserProfile: UpdatedUserProfile, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void)
}

final class UpdateUserProfileService: PartUserProfileUpdating {
    private let resource: PostService<UpdateUserProfileResource>
    
    init(resource: PostService<UpdateUserProfileResource>) {
        self.resource = resource
    }
    
    func update(updatedUserProfile: UpdatedUserProfile, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        resource.post(using: updatedUserProfile, completion: completion)
    }
}
