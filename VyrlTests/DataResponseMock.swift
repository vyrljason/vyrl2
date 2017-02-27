//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Alamofire
@testable import Vyrl

final class DataResponseMock: DataResponseProtocol {
    var request: URLRequest?
    var response: HTTPURLResponse?
    var data: Data?
    var result: Alamofire.Result<Any>

    init(result: Alamofire.Result<Any>) {
        self.result = result
    }

    static func dataWith(json: [String: Any],
                         statusCode: Int = 200,
                         url: URL = URL(string: "https://www.apple.com")!) -> DataResponseMock {
        let response = DataResponseMock(result: .success(json))
        response.data = NSKeyedArchiver.archivedData(withRootObject: json)
        response.response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        return response
    }

    static func dataForValid(apiError: APIError? = nil,
                             error: Error,
                             statusCode: Int = 333,
                             url: URL = URL(string: "https://www.apple.com")!) -> DataResponseMock {
        let response = DataResponseMock(result: .failure(error))
        if let apiError = apiError {
            response.data = try? JSONSerialization.data(withJSONObject: apiError.dictionaryRepresentation, options: JSONSerialization.WritingOptions())
        }
        response.response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        return response
    }
}
