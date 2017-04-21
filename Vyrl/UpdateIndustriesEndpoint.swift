//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct UpdateIndustriesEndpoint: APIEndpoint {
    let path: String = "/user/industry"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .put
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    
    init(updatedUserIndustries: UpdatedUserIndustries) {
        parameters = updatedUserIndustries.dictionaryRepresentation
    }
}
