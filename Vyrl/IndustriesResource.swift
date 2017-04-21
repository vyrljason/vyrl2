//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class IndustriesResource: Fetching, APIResource {
    
    typealias Model = Industries
    
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func fetch(completion: @escaping (Result<Industries, APIResponseError>) -> Void) {
        controller.call(endpoint: IndustriesEndpoint(), completion: completion)
    }
}
