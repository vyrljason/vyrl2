//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class OrderProposalResource: PostingWithParameters, APIResource {

    typealias ResponseModel = Order
    typealias Parameters = OrderProposal
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: OrderProposal, completion: @escaping (Result<Order, APIResponseError>) -> Void) {
        controller.call(endpoint: OrderProposalEndpoint(proposal: parameters), completion: completion)
    }
}
