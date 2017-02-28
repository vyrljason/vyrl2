//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire
@testable import Vyrl

final class SessionManagerMock: SessionManager {
    var lastRequest: URLRequest?

    // swiftlint:disable function_parameter_count
    @discardableResult override func request(_ url: Alamofire.URLConvertible,
                                             method: Alamofire.HTTPMethod,
                                             parameters: Alamofire.Parameters?,
                                             encoding: ParameterEncoding,
                                             headers: HTTPHeaders?) -> Alamofire.DataRequest {
        let request = super.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        lastRequest = request.request
        return request
    }
}
