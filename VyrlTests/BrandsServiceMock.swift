//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import Foundation

final class BrandsServiceMock: BrandsProviding {

    var brands: [Brand] = (0..<5).map { _ in VyrlFaker.faker.brand() }
    let error: ServiceError = .unknown
    var success = true
    var isResponseEmpty: Bool = false
    var category: Vyrl.Category?
    var brandIds: [String]?

    func getFilteredBrands(for category: Vyrl.Category?, completion: @escaping (Result<[Brand], ServiceError>) -> Void) {
        self.category = category
        if success {
            completion(.success(isResponseEmpty ? [] : brands))
        } else {
            completion(.failure(error))
        }
    }

    func getBrands(with brandIds: [String], completion: @escaping (Result<[Brand], ServiceError>) -> Void) {
        self.brandIds = brandIds
        if success {
            completion(.success(isResponseEmpty ? [] : brands))
        } else {
            completion(.failure(error))
        }
    }
}
