//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class ProductsResourceMock: Fetching {
    
    typealias Model = [Product]
    
    private let products: [Product]
    var success = true
    
    init(amount: Int) {
        self.products = (0..<amount).map { _ in VyrlFaker.faker.product() }
    }
    
    func fetch(completion: @escaping (Result<[Product], APIResponseError>) -> Void) {
        if success {
            completion(.success(self.products))
        } else {
            let error = NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil)
            completion(.failure(.unexpectedFailure(error)))
        }
    }
}
