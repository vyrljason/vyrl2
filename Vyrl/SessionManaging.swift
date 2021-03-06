//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

protocol SessionManaging {
    // swiftlint:disable function_parameter_count
    @discardableResult func request(_ url: Alamofire.URLConvertible,
                                    method: Alamofire.HTTPMethod,
                                    parameters: Alamofire.Parameters?,
                                    encoding: ParameterEncoding,
                                    headers: HTTPHeaders?) -> Alamofire.DataRequest
}

extension SessionManager: SessionManaging { }
