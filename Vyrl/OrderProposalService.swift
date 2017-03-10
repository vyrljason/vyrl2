//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol OrderProposalSending {
    func send(proposal: OrderProposal, completion: @escaping (Result<Orders, ServiceError>) -> Void)
}

final class OrderProposalService: OrderProposalSending {
    private let resource: PostService<OrderProposalResource>

    init(resource: PostService<OrderProposalResource>) {
        self.resource = resource
    }

    func send(proposal: OrderProposal, completion: @escaping (Result<Orders, ServiceError>) -> Void) {
        resource.post(using: proposal, completion: completion)
    }
}
