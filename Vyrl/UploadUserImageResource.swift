//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class UploadUserImageResource: PostingWithParameters, APIResource {
    
    typealias ResponseModel = UserImageUploadResponse
    typealias Parameters = UserImageType
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func post(using parameters: UserImageType, completion: @escaping (Result<UserImageUploadResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: UploadUserImageEndpoint(userImageType: parameters), completion: completion)
    }
}
