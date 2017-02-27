//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct APIError {
    fileprivate enum JSONKeys {
        static let error = "error"
        static let statusCode = "statusCode"
        static let name = "name"
        static let message = "message"
    }

    let statusCode: Int
    let name: String
    let message: String
}

extension APIError: Decodable {
    static func decode(_ json: Any) throws -> APIError {
        let errorDictionary = try json => KeyPath(JSONKeys.error)
        return try self.init(statusCode: errorDictionary => KeyPath(JSONKeys.statusCode),
                             name: errorDictionary => KeyPath(JSONKeys.name),
                             message: errorDictionary => KeyPath(JSONKeys.message))
    }
}

extension APIError: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        let apiErrorDictionary: [String: Any] = [JSONKeys.statusCode: statusCode,
                                                 JSONKeys.name: name,
                                                 JSONKeys.message: message]
        return [JSONKeys.error: apiErrorDictionary]
    }
}

extension APIError {
    private enum Constants {
        static let failureStatusCode = 500
    }
    init(error: NSError) {
        self.statusCode = Constants.failureStatusCode
        self.name = error.domain
        self.message = error.localizedDescription
    }
}
