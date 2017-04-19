//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol IndustriesProviding {
    func get(completion: @escaping (Result<[Industry], ServiceError>) -> Void)
}

final class IndustriesService: IndustriesProviding {
    
    private let resource: Service<IndustriesResource>
    
    init(resource: Service<IndustriesResource>) {
        self.resource = resource
    }
    
    func get(completion: @escaping (Result<[Industry], ServiceError>) -> Void) {
        resource.get { (result) in
            completion(result.map(success: { .success($0.industries) }, failure: { .failure($0) }))
        }
    }
}
