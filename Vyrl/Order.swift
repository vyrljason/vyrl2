//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

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

struct Order {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let brandId = "brandId"
        static let influencerId = "influencerId"
        static let status = "status"
        static let orderValue = "orderValue"
        static let shippingAddress = "shippingAddress"
        static let productList = "productList"
        static let contactInfo = "contactInfo"
    }

    let id: String
    let brandId: String
    let influencerId: Double?
    let status: OrderStatus
    let orderValue: Double
    let shippingAddress: ShippingAddress?
    let contactInfo: ContactInfo?
    let productList: [Product]
}

extension Order: Decodable {
    static func decode(_ json: Any) throws -> Order {
        let status: OrderStatus
        if let statusAsString: String = try? json => KeyPath(JSONKeys.status) {
            status = OrderStatus(description: statusAsString)
        } else {
            status = OrderStatus(description: "")
        }
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             brandId: json => KeyPath(JSONKeys.brandId),
                             influencerId: json =>? OptionalKeyPath(stringLiteral: JSONKeys.influencerId),
                             status: status,
                             orderValue: json => KeyPath(JSONKeys.orderValue),
                             shippingAddress: json =>? OptionalKeyPath(stringLiteral: JSONKeys.shippingAddress),
                             contactInfo: json =>? OptionalKeyPath(stringLiteral: JSONKeys.contactInfo),
                             productList: json =>? OptionalKeyPath(stringLiteral: JSONKeys.productList) ?? [])
    }
}
