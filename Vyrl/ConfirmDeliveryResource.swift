//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class ConfirmDeliveryResource: PostingWithParameters, APIResource {

    typealias ResponseModel = EmptyResponse
    typealias Parameters = ConfirmDeliveryRequest
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: ConfirmDeliveryRequest, completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: ConfirmDeliveryEndpoint(request: parameters), completion: completion)
    }
}
