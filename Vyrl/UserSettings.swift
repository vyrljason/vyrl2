//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct UserSettings {
    fileprivate enum JSONKeys {
        static let id = "id"
        static let user = "user"
        static let admin = "admin"
        static let brand = "brand"
        static let influencer = "influencer"
        static let brandRequestClosed = "brandRequestClosed"
        static let brandStatusRequested = "brandStatusRequested"
        static let enableChatRequests = "enableChatRequests"
        static let enableEmailNotifications = "enableEmailNotifications"
        static let enablePushNotifications = "enablePushNotifications"
    }
    let id: Int
    let user: Int
    let isAdmin: Bool
    let isBrand: Bool
    let isInfluencer: Bool
    let brandRequestClosed: Bool
    let brandStatusRequested: Bool
    let chatRequestsEnabled: Bool
    let emailNotificationsEnabled: Bool
    let pushNotificationsEnabled: Bool
}

extension UserSettings: Decodable {
    static func decode(_ json: Any) throws -> UserSettings {
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             user: json => KeyPath(JSONKeys.user),
                             isAdmin: json => KeyPath(JSONKeys.admin),
                             isBrand: json => KeyPath(JSONKeys.brand),
                             isInfluencer: json => KeyPath(JSONKeys.influencer),
                             brandRequestClosed: json => KeyPath(JSONKeys.brandRequestClosed),
                             brandStatusRequested: json => KeyPath(JSONKeys.brandStatusRequested),
                             chatRequestsEnabled: json => KeyPath(JSONKeys.enableChatRequests),
                             emailNotificationsEnabled: json => KeyPath(JSONKeys.enableEmailNotifications),
                             pushNotificationsEnabled: json => KeyPath(JSONKeys.enablePushNotifications))
    }
}
