//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire
@testable import Vyrl

struct APIEndpointMock: APIEndpoint {
    var path: String = "path"
    var authorization: AuthorizationType = .none
    var method: Vyrl.HTTPMethod = .get
    var parameters: [String: Any]?
    var api: APIType = .main
    var encoding: ParameterEncoding = URLEncoding()
}
