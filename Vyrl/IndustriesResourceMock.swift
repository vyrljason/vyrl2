//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class IndustriesResourceMock: Fetching {
    
    typealias Model = [Industry]
    
    let industries: [Industry] = [Industry(id: 0, name: VyrlFaker.faker.lorem.word()),
                                  Industry(id: 1, name: VyrlFaker.faker.lorem.word()),
                                  Industry(id: 2, name: VyrlFaker.faker.lorem.word())]
    
    var success = true
    
    func fetch(completion: @escaping (Result<[Industry], APIResponseError>) -> Void) {
        if success {
            completion(.success(industries))
        } else {
            completion(.failure(.unexpectedFailure(NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil))))
        }
    }
}
