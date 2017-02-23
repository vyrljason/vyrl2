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
        return try self.init(statusCode: json => KeyPath(JSONKeys.error) => KeyPath(JSONKeys.statusCode),
                             name: json => KeyPath(JSONKeys.error) => KeyPath(JSONKeys.name),
                             message: json => KeyPath(JSONKeys.error) => KeyPath(JSONKeys.message))
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
