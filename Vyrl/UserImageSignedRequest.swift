//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct UserImageUploadResponse {
    fileprivate enum JSONKeys {
        static let signedRequest = "signed_request"
        static let url = "url"
    }
    let signedRequest: URL
    let url: URL
}

extension UserImageUploadResponse: Decodable {
    static func decode(_ json: Any) throws -> UserImageUploadResponse {
        guard let imageURL = try URL(string: json => KeyPath(JSONKeys.url)) else {
            throw DecodingError.typeMismatch(expected: URL.self, actual: String.self, DecodingError.Metadata(object: JSONKeys.url))
        }
        guard let signedRequestURL = try URL(string: json => KeyPath(JSONKeys.signedRequest)) else {
            throw DecodingError.typeMismatch(expected: URL.self, actual: String.self, DecodingError.Metadata(object: JSONKeys.signedRequest))
        }
        return self.init(signedRequest: signedRequestURL,
                         url: imageURL)
    }
}
