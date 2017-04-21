//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct UpdateUserSettingsEndpoint: APIEndpoint {
    let path: String = "/user/settings"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .put
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    
    init(userSettings: UserSettings) {
        parameters = userSettings.dictionaryRepresentation
    }
}
