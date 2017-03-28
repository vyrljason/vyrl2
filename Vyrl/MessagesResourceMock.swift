//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class MessagesResourceMock: Fetching {
    
    typealias Model = Messages
    
    let items: Messages
    var success = true
    
    init(amount: Int) {
        items = Messages(messages: (0..<amount).map { index in
            return index % 5 == 0 ? VyrlFaker.faker.systemMessageContainer() : VyrlFaker.faker.messageContainer()
        })
    }
    
    func fetch(completion: @escaping (Result<Messages, APIResponseError>) -> Void) {
        if success {
            completion(.success(items))
        } else {
            completion(.failure(.unexpectedFailure(NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil))))
        }
    }
}
