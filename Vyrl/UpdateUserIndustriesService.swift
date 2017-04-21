//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UserIndustriesUpdating {
    func update(updatedUserIndustries: UpdatedUserIndustries, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void)
}

final class UpdateUserIndustriesService: UserIndustriesUpdating {
    private let resource: PostService<UpdateUserIndustriesResource>
    
    init(resource: PostService<UpdateUserIndustriesResource>) {
        self.resource = resource
    }
    
    func update(updatedUserIndustries: UpdatedUserIndustries, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        resource.post(using: updatedUserIndustries, completion: completion)
    }
}
