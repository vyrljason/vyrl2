//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

enum UserImageType: CustomStringConvertible {
    case avatar
    case discoveryFeed
    
    var description: String {
        switch self {
        case .avatar:
            return "avatar"
        case .discoveryFeed:
            return "dfi"
        }
    }
}

struct UploadUserImageEndpoint: APIEndpoint {
    let userImageType: UserImageType
    let path: String
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .put
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = JSONEncoding()
    
    init(userImageType: UserImageType) {
        self.userImageType = userImageType
        self.path = "user/upload/" + userImageType.description
        parameters = ["fileType" : "image/png"]
    }
}
