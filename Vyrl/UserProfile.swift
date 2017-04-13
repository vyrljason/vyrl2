//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct UserProfile {
    fileprivate enum JSONKeys {
        static let avatar = "avatar"
        static let bio = "bio"
        static let discoveryFeedImage = "discoveryFeedImage"
        static let discoveryFilterSettings = "discoveryFilterSettings"
        static let email = "email"
        static let fullName = "fullName"
        static let id = "id"
        static let industries = "industries"
        static let instagramProfile = "instagramProfile"
        static let location = "location"
        static let pendingEmail = "pendingEmail"
        static let isPlatformConfirmed = "platformConfirmed"
        static let settings = "settings"
        static let tagline = "tagline"
        static let username = "username"
    }
    let id: Int
    let avatar: URL?
    let bio: String
    let discoveryFeedImage: URL?
    let email: String?
    let fullName: String
    let pendingEmail: String?
    let isPlatformConfirmed: Bool
    let tagline: String
    let username: String
    let settings: UserSettings
    let instagramProfile: SocialNetworkProfile?
//    let location: Location?
    let industries: [Industry]
}

extension UserProfile: Decodable {
    static func decode(_ json: Any) throws -> UserProfile {
        var avatarURL: URL? = nil
        if let avatar = try json =>? OptionalKeyPath(stringLiteral: JSONKeys.avatar) as? String {
            avatarURL = URL(string: avatar)
        }
        var discoveryFeedImageURL: URL? = nil
        if let discoveryFeedImage = try json =>? OptionalKeyPath(stringLiteral: JSONKeys.discoveryFeedImage) as? String {
            discoveryFeedImageURL = URL(string: discoveryFeedImage)
        }
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             avatar: avatarURL,
                             bio: json => KeyPath(JSONKeys.bio),
                             discoveryFeedImage: discoveryFeedImageURL,
                             email: json =>? OptionalKeyPath(stringLiteral: JSONKeys.email),
                             fullName: json => KeyPath(JSONKeys.fullName),
                             pendingEmail: json =>? OptionalKeyPath(stringLiteral: JSONKeys.pendingEmail),
                             isPlatformConfirmed: json => KeyPath(JSONKeys.isPlatformConfirmed),
                             tagline: json => KeyPath(JSONKeys.tagline),
                             username: json => KeyPath(JSONKeys.username),
                             settings: json => KeyPath(JSONKeys.settings),
                             instagramProfile: json =>? OptionalKeyPath(stringLiteral: JSONKeys.instagramProfile),
                             industries: json => KeyPath(JSONKeys.industries))
    }
}
