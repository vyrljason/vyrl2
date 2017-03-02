//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class BrandsResource: FetchingWithParameters, APIResource {

    typealias Model = Brands
    typealias Parameters = BrandsRequest
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func fetchFiltered(using parameters: BrandsRequest?, completion: @escaping (Result<Brands, APIResponseError>) -> Void) {
        controller.call(endpoint: BrandsEndpoint(request: parameters), completion: completion)
    }
}
