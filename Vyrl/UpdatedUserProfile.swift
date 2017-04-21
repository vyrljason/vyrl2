//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct UpdatedUserProfile {
    fileprivate enum JSONKeys {
        static let avatar = "avatar"
        static let discoveryFeedImage = "discoveryFeedImage"
        static let bio = "bio"
        static let fullName = "fullName"
    }
    let avatar: URL?
    let discoveryFeedImage: URL?
    let bio: String
    let fullName: String
}

extension UpdatedUserProfile: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [JSONKeys.bio: bio,
                                   JSONKeys.fullName: fullName]
        if let avatar = avatar {
            dict[JSONKeys.avatar] = avatar.absoluteString
        }
        
        if let discoveryFeedImage = discoveryFeedImage {
            dict[JSONKeys.discoveryFeedImage] = discoveryFeedImage.absoluteString
        }
        return dict
        
    }
}
