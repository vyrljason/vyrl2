//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPMethod: String, CustomStringConvertible {
    case get
    case post
    case put
    case delete
    case patch

    public var description: String {
        return self.rawValue.uppercased()
    }
}

extension Vyrl.HTTPMethod {
    var alamofireMethod: Alamofire.HTTPMethod {
        switch self {
        case .get: return Alamofire.HTTPMethod.get
        case .post: return Alamofire.HTTPMethod.post
        case .put: return Alamofire.HTTPMethod.put
        case .delete: return Alamofire.HTTPMethod.delete
        case .patch: return Alamofire.HTTPMethod.patch
        }
    }
}

enum StatusCode: Int {
    case ok
    case accessDenied
    case notFound
    case failure

    public init(rawValue: Int) {
        switch rawValue {
        case 200...299: self = .ok
        case 401, 403: self = .accessDenied
        case 404: self = .notFound
        default: self = .failure
        }
    }
}
