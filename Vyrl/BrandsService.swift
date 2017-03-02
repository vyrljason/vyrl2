//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol BrandsProviding {
    func get(completion: @escaping (Result<[Brand], ServiceError>) -> Void)
}

final class BrandsService: BrandsProviding {

    private let resource: Service<BrandsResource>

    init(resource: Service<BrandsResource>) {
        self.resource = resource
    }

    func get(completion: @escaping (Result<[Brand], ServiceError>) -> Void) {
        resource.get { (result) in
            completion(result.map(success: { .success($0.brands) }, failure: { .failure($0) }))
        }
    }
}
