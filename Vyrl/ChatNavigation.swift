//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ChatNavigating: class {
    weak var chatNavigationController: UINavigationController? { get set }
    var collabs: CollabsViewController! { get }
}

protocol MessagesPresenting: class {
    func presentMessages(for collab: Collab, animated: Bool)
}

final class ChatNavigationBuilder {
    var collabsFactory: CollabsControllerMaking.Type = CollabsViewControllerFactory.self
    var messagesFactory: MessagesControllerMaking.Type = MessagesViewControllerFactory.self
    
    func build() -> ChatNavigating {
        return ChatNavigation(collabsFactory: collabsFactory, messagesFactory: messagesFactory)
    }
}

final class ChatNavigation: ChatNavigating {
    weak var chatNavigationController: UINavigationController?
    var collabs: CollabsViewController!
    fileprivate let collabsFactory: CollabsControllerMaking.Type
    fileprivate let messagesFactory: MessagesControllerMaking.Type
    
    init (collabsFactory: CollabsControllerMaking.Type, messagesFactory: MessagesControllerMaking.Type) {
        self.collabsFactory = collabsFactory
        self.messagesFactory = messagesFactory
        collabs = collabsFactory.make(presenter: self)
    }
}

extension ChatNavigation: MessagesPresenting {
    func presentMessages(for collab: Collab, animated: Bool) {
        let viewController = messagesFactory.make(collab: collab)
        chatNavigationController?.pushViewController(viewController, animated: animated)
    }
}
