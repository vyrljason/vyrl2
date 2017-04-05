//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ContentStatus: CustomStringConvertible {
    case none
    case pending
    case declined
    case approved

    var description: String {
        switch self {
        case .none: return "NONE"
        case .pending: return "PENDING"
        case .declined: return "DECLINED"
        case .approved: return "APPROVED"
        }
    }

    // swiftlint:disable cyclomatic_complexity
    init(description: String) {
        switch description {
        case ContentStatus.pending.description:
            self = .pending
        case ContentStatus.declined.description:
            self = .declined
        case ContentStatus.approved.description:
            self = .approved
        default:
            self = .none
        }
    }
}
