//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

fileprivate enum Constants {
    static let systemSenderId = "-1"
}

enum MessageType {
    case system
    case brand
    case influencer
}

struct MessageContainer: Equatable {
    fileprivate struct JSONKeys {
        static let createdAt = "createdAt"
        static let sender = "sender"
        static let message = "message"
    }
    
    let createdAt: Date
    let sender: Sender
    let message: Message

    func messageType(in collab: Collab) -> MessageType {
        switch sender.id {
        case collab.chatRoom.influencerId:
            return .influencer
        case Constants.systemSenderId:
            return .system
        default:
            return .brand
        }
    }
}

extension MessageContainer: Decodable {
    static func decode(_ json: Any) throws -> MessageContainer {
        return try self.init(createdAt: Date(timeIntervalSince1970: json => KeyPath(JSONKeys.createdAt)),
                             sender: json => KeyPath(JSONKeys.sender),
                             message: json => KeyPath(JSONKeys.message))
    }
}

func == (lhs: MessageContainer, rhs: MessageContainer) -> Bool {
    return lhs.createdAt == rhs.createdAt && lhs.sender == rhs.sender && lhs.message == rhs.message
}
