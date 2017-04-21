//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UserDeleting {
    func delete(completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void)
}

final class DeleteUserService: UserDeleting {
    private let resource: Service<DeleteUserResource>
    
    init(resource: Service<DeleteUserResource>) {
        self.resource = resource
    }
    
    func delete(completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        resource.get(completion: completion)
    }
}
