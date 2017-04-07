//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static let previousOrderNotFinishedStatusCode: Int = 422
    static let checkoutError =  NSLocalizedString("checkout.error.api", comment: "")
    static let checkoutErrorTitle =  NSLocalizedString("checkout.error.title", comment: "")
}

enum OrderProposalError: Error {
    case previousOrderNotFinished(String)
    case unknown
    
    var message: String {
        switch self {
        case .previousOrderNotFinished(let message): return message
        case .unknown: return Constants.checkoutError
        }
    }
    
    var title: String {
        return Constants.checkoutErrorTitle
    }
    
    init(serviceError: ServiceError) {
        guard case .apiResponseError(let apiResponseError) = serviceError else {
            self = .unknown
            return
        }
        guard case .apiRequestError(let apiError) = apiResponseError  else {
            self = .unknown
            return
        }
        switch apiError.statusCode {
        case Constants.previousOrderNotFinishedStatusCode:
            self = .previousOrderNotFinished(apiError.message)
        default:
            self = .unknown
        }
    }
}

protocol OrderProposalSending {
    func send(proposal: OrderProposal, completion: @escaping (Result<Orders, OrderProposalError>) -> Void)
}

final class OrderProposalService: OrderProposalSending {
    private let resource: PostService<OrderProposalResource>

    init(resource: PostService<OrderProposalResource>) {
        self.resource = resource
    }

    func send(proposal: OrderProposal, completion: @escaping (Result<Orders, OrderProposalError>) -> Void) {
        resource.post(using: proposal) { result in
            completion(result.map(success: { .success($0) }, failure: { error in
                return .failure(OrderProposalError(serviceError: error))
            }))
        }
    }
}
