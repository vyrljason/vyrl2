//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol BrandsProviding {
    func getFilteredBrands(for category: Category?, completion: @escaping (Result<[Brand], ServiceError>) -> Void)
    func getBrands(with brandIds: [String], completion: @escaping (Result<[Brand], ServiceError>) -> Void)
}

final class BrandsService: BrandsProviding {

    private let resource: ParameterizedService<BrandsResource>

    init(resource: ParameterizedService<BrandsResource>) {
        self.resource = resource
    }

    func getFilteredBrands(for category: Category? = nil, completion: @escaping (Result<[Brand], ServiceError>) -> Void) {
        resource.get(using: BrandsRequest(category: category)) { result in
            completion(result.map(success: { .success($0.brands) }, failure: { .failure($0) }))
        }
    }

    func getBrands(with brandIds: [String], completion: @escaping (Result<[Brand], ServiceError>) -> Void) {
        
    }
}
