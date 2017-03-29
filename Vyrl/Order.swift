//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

enum OrderStatus: String, CustomStringConvertible {
    case requested = "REQUESTED"
    case declined = "DECLINED"
    case accepted = "ACCEPTED"
    case shipped = "SHIPPED"
    case delivered = "DELIVERED"
    case posted = "POSTED"

    var description: String {
        return rawValue
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
        guard let statusAsString: String = try json => KeyPath(JSONKeys.status) else {
            throw DecodingError.missingKey("status", DecodingError.Metadata(object: JSONKeys.status))
        }
        guard let status: OrderStatus = OrderStatus(rawValue: statusAsString) else {
            throw DecodingError.rawRepresentableInitializationError(rawValue: statusAsString, DecodingError.Metadata(object: JSONKeys.status))
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
