//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Collab {
    fileprivate enum JSONKeys {
        static let name = "name"
        static let author = "author"
        static let lastMessage = "lastMessage"
    }

    let brandName: String
    let authorName: String?
    let lastMessage: String
}

extension Collab: Decodable {
    static func decode(_ json: Any) throws -> Collab {
        return try self.init(brandName: json => KeyPath(JSONKeys.name),
                             authorName: json => KeyPath(JSONKeys.author),
                             lastMessage: json => KeyPath(JSONKeys.lastMessage))
    }
}

struct ChatRoom {
    fileprivate enum Keys {
        static let brandId = "brandId"
        static let influencerId = "influencerId"
        static let lastMessage = "lastMessage"
        static let status = "status"
        static let unreadMessages = "unread"
    }
    let brandId: String
    let influencerId: String
    let lastMessage: String
    let status: OrderStatus
    let unreadMessages: Int
}

extension ChatRoom: DictionaryInitializable {
    init?(dictionary: [AnyHashable: Any]?) {
        guard let dictionary = dictionary as? [String: Any] else { return nil }
        guard let brandId = dictionary[Keys.brandId] as? String else { return nil }
        guard let influencerId = dictionary[Keys.influencerId] as? String else { return nil }
        guard let lastMessage = dictionary[Keys.lastMessage] as? String else { return nil }
        guard let statusAsString = dictionary[Keys.status] as? String, let status = OrderStatus(rawValue: statusAsString) else { return nil }
        guard let unreadMessages = dictionary[Keys.unreadMessages] as? Int else { return nil }

        self.brandId = brandId
        self.influencerId = influencerId
        self.lastMessage = lastMessage
        self.status = status
        self.unreadMessages = unreadMessages
    }
}

extension ChatRoom: Decodable {
    static func decode(_ json: Any) throws -> ChatRoom {
        guard let statusAsString = try json => KeyPath(Keys.status) as? String, let status = OrderStatus(rawValue: statusAsString) else {
            throw DecodingError.typeMismatch(expected: OrderStatus.self, actual: String.self, DecodingError.Metadata(object: Keys.status))
        }
        return try self.init(brandId: json => KeyPath(Keys.brandId),
                             influencerId: json => KeyPath(Keys.influencerId),
                             lastMessage: json => KeyPath(Keys.lastMessage),
                             status: status,
                             unreadMessages: json => KeyPath(Keys.unreadMessages))
    }
}
