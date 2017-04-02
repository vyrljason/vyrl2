//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol MessageSending {
    func send(message: Message, toRoom roomId: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void)
}

final class PostMessageService: MessageSending {
    private let resource: PostService<PostMessageResource>

    init(resource: PostService<PostMessageResource>) {
        self.resource = resource
    }

    func send(message: Message, toRoom roomId: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        resource.post(using: PostMessage(roomId: roomId, message: message), completion: completion)
    }
}
