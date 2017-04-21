//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class UpdateUserProfileResource: PostingWithParameters, APIResource {
    
    typealias ResponseModel = EmptyResponse
    typealias Parameters = UpdatedUserProfile
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func post(using parameters: UpdatedUserProfile, completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: UpdateUserProfileEndpoint(updatedUserProfile: parameters), completion: completion)
    }
}
