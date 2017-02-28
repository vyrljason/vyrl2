//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

protocol DataResponseProtocol {
    associatedtype Value
    var request: URLRequest? { get }
    var response: HTTPURLResponse? { get }
    var data: Data? { get }
    var jsonResult: Alamofire.Result<Value> { get }
}

extension DataResponse: DataResponseProtocol {
    internal var jsonResult: Alamofire.Result<Value> {
        return result
    }
}
