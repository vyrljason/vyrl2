//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class BrandsResource: Fetching, APIResource {

    typealias Model = Brands

    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func fetch(completion: @escaping (Result<Brands, APIResponseError>) -> Void) {
        controller.call(endpoint: BrandsEndpoint(), completion: completion)
    }
}
