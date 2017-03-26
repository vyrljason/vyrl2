//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

enum MessageType {
    private enum Constants {
        static let systemSenderId = "-1"
    }
    
    case system
    case normal

    static func type(for senderId: String) -> MessageType {
        return senderId == Constants.systemSenderId ? .system : . normal
    }
}

struct MessageContainer {
    fileprivate struct JSONKeys {
        static let createdAt = "createdAt"
        static let sender = "sender"
        static let message = "message"
    }
    
    let createdAt: Double
    let sender: Sender
    let message: Message
    let messageType: MessageType
}

extension MessageContainer: Decodable {
    static func decode(_ json: Any) throws -> MessageContainer {
        guard let sender: Sender = try json => KeyPath(JSONKeys.message) else {
            throw DecodingError.missingKey("sender", DecodingError.Metadata(object: JSONKeys.sender))
        }
        
        let messageType = MessageType.type(for: sender.id)

        return try self.init(createdAt: json => KeyPath(JSONKeys.createdAt),
                             sender: sender,
                             message: json => KeyPath(JSONKeys.message),
                             messageType: messageType)
    }
}
