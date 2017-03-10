//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class OrderProposalResource: PostingWithParameters, APIResource {

    typealias ResponseModel = Orders
    typealias Parameters = OrderProposal
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func post(using parameters: OrderProposal, completion: @escaping (Result<Orders, APIResponseError>) -> Void) {
        controller.call(endpoint: OrderProposalEndpoint(proposal: parameters), completion: completion)
    }
}
