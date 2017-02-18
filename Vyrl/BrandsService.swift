//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum BrandsError: Error {
    case unknown
}

typealias BrandsResultClosure = (Result<[Brand], BrandsError>) -> Void
typealias BrandsAPIResultClosure = (Result<[Brand], APIResponseError>) -> Void

protocol BrandsHaving {
    func brands(completion: @escaping BrandsResultClosure)
}

final class BrandsService: BrandsHaving {

    let resource: BrandsFetching

    init(resource: BrandsFetching) {
        self.resource = resource
    }

    func brands(completion: @escaping BrandsResultClosure) {
        resource.brands { result in
            switch result {
            case .success(let newBrands):
                completion(.success(newBrands))
            case .failure:
                completion(.failure(.unknown))
            }
        }
    }
    
}
