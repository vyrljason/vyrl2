//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class UpdateUserIndustriesResource: PostingWithParameters, APIResource {
    
    typealias ResponseModel = EmptyResponse
    typealias Parameters = UpdatedUserIndustries
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func post(using parameters: UpdatedUserIndustries, completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: UpdateIndustriesEndpoint(updatedUserIndustries: parameters), completion: completion)
    }
}
