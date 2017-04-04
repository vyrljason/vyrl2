//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class PostImageResource: PostingWithParameters, APIResource {

    typealias ResponseModel = EmptyResponse
    typealias Parameters = ImageMessage
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: ImageMessage, completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: PostImageEndpoint(message: parameters), completion: completion)
    }
}
