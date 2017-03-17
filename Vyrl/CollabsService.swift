//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol CollabsProviding {
    func getCollabs(completion: @escaping (Result<[Collab], ServiceError>) -> Void)
}

final class CollabsService: CollabsProviding {

    private let resource: Service<CollabsResourceMock>

    init(resource: Service<CollabsResourceMock>) {
        self.resource = resource
    }

    func getCollabs(completion: @escaping (Result<[Collab], ServiceError>) -> Void) {
        resource.get { result in
            completion(result.map(success: { .success($0.collabs) }, failure: { .failure($0) }))
        }
    }
}
