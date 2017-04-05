//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct ChatRoom {
    fileprivate enum Keys {
        static let brandId = "brandId"
        static let influencerId = "influencerId"
        static let lastMessage = "lastMessage"
        static let lastActivity = "lastActivity"
        static let orderStatus = "status"
        static let contentStatus = "contentStatus"
        static let unreadMessages = "unread"
    }

    static let orderStatusKey = Keys.orderStatus
    static let contentStatusKey = Keys.contentStatus

    let brandId: String
    let influencerId: String
    let lastMessage: String
    let lastActivity: Date
    let orderStatus: OrderStatus
    let contentStatus: ContentStatus
    let unreadMessages: Int
}

extension ChatRoom: DictionaryInitializable {
    init?(dictionary: [AnyHashable: Any]?) {
        guard let dictionary = dictionary as? [String: Any] else { return nil }
        guard let brandId = dictionary[Keys.brandId] as? String else { return nil }
        guard let influencerId = dictionary[Keys.influencerId] as? String else { return nil }
        guard let lastMessage = dictionary[Keys.lastMessage] as? String else { return nil }
        guard let lastActivity = dictionary[Keys.lastActivity] as? TimeInterval else { return nil }
        guard let unreadMessages = dictionary[Keys.unreadMessages] as? Int else { return nil }
        let orderStatusAsString = dictionary[Keys.orderStatus] as? String ?? ""
        let contentStatusAsString = dictionary[Keys.contentStatus] as? String ?? ""

        self.brandId = brandId
        self.influencerId = influencerId
        self.lastMessage = lastMessage
        self.lastActivity = Date(timeIntervalSince1970: lastActivity)
        self.orderStatus = OrderStatus(description: orderStatusAsString)
        self.contentStatus = ContentStatus(description: contentStatusAsString)
        self.unreadMessages = unreadMessages
    }
}

extension ChatRoom: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [Keys.brandId: brandId,
                Keys.influencerId: influencerId,
                Keys.lastMessage: lastMessage,
                Keys.lastActivity: lastActivity,
                Keys.orderStatus: orderStatus.description,
                Keys.contentStatus: contentStatus.description,
                Keys.unreadMessages: unreadMessages]
    }
}
