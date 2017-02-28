//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct DiscoveryFilterSettings {
    fileprivate enum JSONKeys {
        static let minFollowers = "minFollowers"
        static let maxFollowers = "maxFollowers"
        static let radius = "radius"
        static let industry = "industry"
    }
    let minFollowers: Int
    let maxFollowers: Int
    let radius: Int?
    let industry: [IndustryId]?

    var isFollowersCountFilterOn: Bool {
        return minFollowers != 0
    }

    var isLocationFilterOn: Bool {
        return radius != nil
    }

    var isIndustryFilterOn: Bool {
        return industry != nil
    }
}

extension DiscoveryFilterSettings: Decodable {
    static func decode(_ json: Any) throws -> DiscoveryFilterSettings {
        return try self.init(minFollowers: json =>? OptionalKeyPath(stringLiteral: JSONKeys.minFollowers) ?? 0,
                             maxFollowers: json =>? OptionalKeyPath(stringLiteral: JSONKeys.maxFollowers) ?? Int.max,
                             radius: json =>? OptionalKeyPath(stringLiteral: JSONKeys.radius),
                             industry: json =>? OptionalKeyPath(stringLiteral: JSONKeys.industry))
    }
}
