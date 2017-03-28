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
        static let status = "status"
        static let unreadMessages = "unread"
    }
    let brandId: String
    let influencerId: String
    let lastMessage: String
    let lastActivity: Date
    let status: OrderStatus?
    let unreadMessages: Int
}

extension ChatRoom: DictionaryInitializable {
    init?(dictionary: [AnyHashable: Any]?) {
        guard let dictionary = dictionary as? [String: Any] else { return nil }
        guard let brandId = dictionary[Keys.brandId] as? String else { return nil }
        guard let influencerId = dictionary[Keys.influencerId] as? String else { return nil }
        guard let lastMessage = dictionary[Keys.lastMessage] as? String else { return nil }
        guard let lastActivity = dictionary[Keys.lastActivity] as? TimeInterval else { return nil }
        guard let statusAsString = dictionary[Keys.status] as? String else { return nil }
        guard let unreadMessages = dictionary[Keys.unreadMessages] as? Int else { return nil }

        self.brandId = brandId
        self.influencerId = influencerId
        self.lastMessage = lastMessage
        self.lastActivity = Date(timeIntervalSince1970: lastActivity)
        self.status = OrderStatus(rawValue: statusAsString)
        self.unreadMessages = unreadMessages
    }
}
