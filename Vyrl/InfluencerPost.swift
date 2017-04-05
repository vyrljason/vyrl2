//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct InfluencerPosts {
    let posts: [InfluencerPost]
}

extension InfluencerPosts: Decodable {
    static func decode(_ json: Any) throws -> InfluencerPosts {
        return try self.init(posts: [InfluencerPost].decode(json))
    }
}

struct InfluencerPost {
    fileprivate struct JSONKeys {
        static let approved = "approved"
        static let mediaURL = "mediaUrl"
        static let status = "status"
        static let description = "description"
        static let brandId = "brandId"
        static let orderId = "orderId"
        static let id = "id"
        static let lastModified = "lastModified"
    }

    let isApproved: Bool
    let status: OrderStatus
    let mediaUrl: URL?
    let brandId: String
    let description: String
    let id: String
    let orderId: String
    let lastModified: String
}

extension InfluencerPost: Decodable {
    static func decode(_ json: Any) throws -> InfluencerPost {
        return try self.init(isApproved: json => KeyPath(JSONKeys.approved),
                             status: OrderStatus(description: json => KeyPath(JSONKeys.status)),
                             mediaUrl: URL(string: json =>? OptionalKeyPath(stringLiteral: JSONKeys.mediaURL) ?? ""),
                             brandId: json => KeyPath(JSONKeys.brandId),
                             description: json => KeyPath(JSONKeys.description),
                             id: json => KeyPath(JSONKeys.id),
                             orderId: json => KeyPath(JSONKeys.orderId),
                             lastModified: json => KeyPath(JSONKeys.lastModified))
    }
}
