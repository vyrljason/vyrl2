//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

enum MessageType {
    case system
    case normal
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
        
        var messageType = MessageType.normal
        if isSystemMessage(sender: sender) {
            messageType = MessageType.system
        }

        return try self.init(createdAt: json => KeyPath(JSONKeys.createdAt),
                             sender: sender,
                             message: json => KeyPath(JSONKeys.message),
                             messageType: messageType)
    }
    
    static func isSystemMessage(sender: Sender) -> Bool {
        return sender.id == "-1"
    }
}
