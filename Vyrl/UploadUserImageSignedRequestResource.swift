//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class UploadUserImageSignedRequestResource: Uploading, APIResource {
    
    typealias ResponseModel = EmptyResponse
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func upload(using dataUrl: URL, toStringUrl: String, completion: @escaping (Result<ResponseModel, APIResponseError>) -> Void) {
        controller.upload(endpoint: UploadUserImageSignedRequestEndpoint(signedRequest: toStringUrl), dataUrl: dataUrl, completion: completion)
    }
}
