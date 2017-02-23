//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

protocol SessionManaging {
    @discardableResult func request(_ url: Alamofire.URLConvertible,
                                    method: Alamofire.HTTPMethod,
                                    parameters: Alamofire.Parameters?,
                                    encoding: ParameterEncoding,
                                    headers: HTTPHeaders?) -> Alamofire.DataRequest
}

extension SessionManager: SessionManaging { }
