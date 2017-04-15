//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class DeleteUserResource: Fetching, APIResource {
    
    typealias ResponseModel = EmptyResponse
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func fetch(completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: DeleteUserEndpoint(), completion: completion)
    }
}
