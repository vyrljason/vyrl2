//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class PostInstagramResource: PostingWithParameters, APIResource {

    typealias ResponseModel = EmptyResponse
    typealias Parameters = InstagramPost
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: InstagramPost, completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: PostInstagramEndpoint(post: parameters), completion: completion)
    }
}
