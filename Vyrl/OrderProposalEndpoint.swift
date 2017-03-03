//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct OrderProposalEndpoint: APIEndpoint {
    let path = "/order/proposal"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = JSONEncoding()

    init(proposal: OrderProposal) {
        parameters = proposal.dictionaryRepresentation
    }
}
