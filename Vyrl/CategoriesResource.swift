//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class CategoriesResource: Fetching, APIResource {

    typealias Model = Categories

    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func fetch(completion: @escaping (Result<Categories, APIResponseError>) -> Void) {
        controller.call(endpoint: CategoriesEndpoint(), completion: completion)
    }
}
