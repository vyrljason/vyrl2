//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

protocol DataResponseProtocol {
    var request: URLRequest? { get }
    var response: HTTPURLResponse? { get }
    var data: Data? { get }
    var result: Alamofire.Result<Any> { get }
}

extension DataResponse: DataResponseProtocol {
    var result: Alamofire.Result<Any> {
        return self.result
    }
}
