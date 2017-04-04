//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class PostImageResource: PostingWithParameters, APIResource {

    typealias ResponseModel = InfluencerPost
    typealias Parameters = ImageMessage
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: ImageMessage, completion: @escaping (Result<InfluencerPost, APIResponseError>) -> Void) {
        controller.call(endpoint: PostImageEndpoint(message: parameters), completion: completion)
    }
}
