//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct UserSettings {
    fileprivate enum JSONKeys {
        static let enableChatRequests = "enableChatRequests"
        static let enableEmailNotifications = "enableEmailNotifications"
        static let enablePushNotifications = "enablePushNotifications"
    }
    let chatRequestsEnabled: Bool
    let emailNotificationsEnabled: Bool
    let pushNotificationsEnabled: Bool
}

extension UserSettings: Decodable {
    static func decode(_ json: Any) throws -> UserSettings {
        return try self.init(chatRequestsEnabled: json => KeyPath(JSONKeys.enableChatRequests),
                             emailNotificationsEnabled: json => KeyPath(JSONKeys.enableEmailNotifications),
                             pushNotificationsEnabled: json => KeyPath(JSONKeys.enablePushNotifications))
    }
}

extension UserSettings: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.enableChatRequests: chatRequestsEnabled,
                JSONKeys.enableEmailNotifications: emailNotificationsEnabled,
                JSONKeys.enablePushNotifications: pushNotificationsEnabled]
    }
}
