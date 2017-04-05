//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class PostInstagramResource: PostingWithParameters, APIResource {

    typealias ResponseModel = InfluencerPost
    typealias Parameters = InstagramPost
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: InstagramPost, completion: @escaping (Result<InfluencerPost, APIResponseError>) -> Void) {
        controller.call(endpoint: PostInstagramEndpoint(post: parameters), completion: completion)
    }
}
