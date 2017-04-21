//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol Uploading {
    associatedtype ResponseModel
    func upload(using dataUrl: URL, toStringUrl: String, completion: @escaping (Result<ResponseModel, APIResponseError>) -> Void)
}

final class UploadService<Resource: Uploading> {
    
    private let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    func upload(using dataUrl: URL, toStringUrl: String, completion: @escaping (Result<Resource.ResponseModel, ServiceError>) -> Void) {
        resource.upload(using: dataUrl, toStringUrl: toStringUrl) { result in
            switch result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(.apiResponseError(error)))
            }
        }
    }
}
