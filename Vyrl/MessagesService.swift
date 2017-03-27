//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol MessagesProviding {
    func getMessages(completion: @escaping (Result<[MessageContainer], ServiceError>) -> Void)
}

final class MessagesService: MessagesProviding {
    
    private let resource: Service<MessagesResourceMock>
    
    init(resource: Service<MessagesResourceMock>) {
        self.resource = resource
    }
    
    func getMessages(completion: @escaping (Result<[MessageContainer], ServiceError>) -> Void) {
        resource.get { result in
            completion(result.map(success: { .success($0.messages) }, failure: { .failure($0) }))
        }
    }
}
