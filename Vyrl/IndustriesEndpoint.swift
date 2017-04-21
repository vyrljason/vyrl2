//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct IndustriesEndpoint: APIEndpoint {
    let path = "/industry"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .get
    let parameters: [String: Any]? = nil
    let api: APIType = .influencers
    let encoding: ParameterEncoding = URLEncoding()
    
}
