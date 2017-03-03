//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol OrderProposalSending {
    func send(proposal: OrderProposal, completion: @escaping (Result<Order, ServiceError>) -> Void)
}

final class OrderProposalService: OrderProposalSending {
    private let resource: PostService<OrderProposalResource>

    init(resource: PostService<OrderProposalResource>) {
        self.resource = resource
    }

    func send(proposal: OrderProposal, completion: @escaping (Result<Order, ServiceError>) -> Void) {
        resource.post(using: proposal, completion: completion)
    }
}
