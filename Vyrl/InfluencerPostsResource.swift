//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class InfluencerPostsResource: PostingWithParameters, APIResource {

    typealias ResponseModel = InfluencerPosts
    typealias Parameters = InfluencerPostsRequest
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: InfluencerPostsRequest, completion: @escaping (Result<InfluencerPosts, APIResponseError>) -> Void) {
        controller.call(endpoint: InfluencerPostsEndpoint(request: parameters), completion: completion)
    }
}
