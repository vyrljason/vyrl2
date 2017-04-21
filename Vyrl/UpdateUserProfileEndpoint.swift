//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct UpdateUserProfileEndpoint: APIEndpoint {
    let path: String = "/user"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .put
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    
    init(updatedUserProfile: UpdatedUserProfile) {
        parameters = updatedUserProfile.dictionaryRepresentation
    }
}
