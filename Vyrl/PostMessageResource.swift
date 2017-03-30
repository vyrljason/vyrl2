//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class PostMessageResource: PostingWithParameters, APIResource {

    typealias ResponseModel = EmptyResponse
    typealias Parameters = PostMessage
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: PostMessage, completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: PostMessageEndpoint(room: parameters.roomId, message: parameters.message), completion: completion)
    }
}
