//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum OrderStatus: CustomStringConvertible {
    case requested
    case declined
    case accepted
    case shipped
    case delivered
    case posted
    case custom(String)

    var description: String {
        switch self {
        case .requested: return "REQUESTED"
        case .declined: return "DECLINED"
        case .accepted: return "ACCEPTED"
        case .shipped: return "SHIPPED"
        case .delivered: return "DELIVERED"
        case .posted: return "POSTED"
        case .custom(let description): return description
        }
    }

    // swiftlint:disable cyclomatic_complexity
    init(description: String) {
        switch description {
        case OrderStatus.requested.description:
            self = .requested
        case OrderStatus.declined.description:
            self = .declined
        case OrderStatus.accepted.description:
            self = .accepted
        case OrderStatus.shipped.description:
            self = .shipped
        case OrderStatus.delivered.description:
            self = .delivered
        case OrderStatus.posted.description:
            self = .posted
        default:
            self = .custom(description)
        }
    }
}
