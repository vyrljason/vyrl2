//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let navigationBarRenderable = NavigationBarRenderable(tintColor: .white,
                                                                 titleFont: .titleFont,
                                                                 backgroundColor: .rouge,
                                                                 translucent: false)
}

protocol ChatNavigating: class {
    weak var chatNavigationController: UINavigationController? { get set }
    var collabs: CollabsViewController! { get }
}

protocol MessagesPresenting: class {
    func presentMessages(for collab: Collab, animated: Bool)
}

protocol ComposePresenting: class {
    func presentCompose(for collab: Collab, animated: Bool)
}

@objc protocol ComposeClosing: class {
    func finishPresentation()
}

final class ChatNavigationBuilder {
    var collabsFactory: CollabsControllerMaking.Type = CollabsViewControllerFactory.self
    var messagesFactory: MessagesControllerMaking.Type = MessagesViewControllerFactory.self
    var composeFactory: ComposeControllerMaking.Type = ComposeViewControllerFactory.self
    
    func build() -> ChatNavigating {
        return ChatNavigation(collabsFactory: collabsFactory, messagesFactory: messagesFactory, composeFactory: composeFactory)
    }
}

final class ChatNavigation: ChatNavigating {
    weak var chatNavigationController: UINavigationController?
    var collabs: CollabsViewController!
    fileprivate let collabsFactory: CollabsControllerMaking.Type
    fileprivate let messagesFactory: MessagesControllerMaking.Type
    fileprivate let composeFactory: ComposeControllerMaking.Type
    
    init (collabsFactory: CollabsControllerMaking.Type, messagesFactory: MessagesControllerMaking.Type, composeFactory: ComposeControllerMaking.Type) {
        self.collabsFactory = collabsFactory
        self.messagesFactory = messagesFactory
        self.composeFactory = composeFactory
        collabs = collabsFactory.make(presenter: self)
    }
}

extension ChatNavigation: MessagesPresenting {
    func presentMessages(for collab: Collab, animated: Bool) {
        let viewController = messagesFactory.make(collab: collab, presenter: self)
        chatNavigationController?.pushViewController(viewController, animated: animated)
    }
}

extension ChatNavigation: ComposePresenting {
    func presentCompose(for collab: Collab, animated: Bool) {
        let viewController = composeFactory.make(collab: collab, closer: self)
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.render(Constants.navigationBarRenderable)
        chatNavigationController?.present(navigation, animated: true)
    }
}

extension ChatNavigation: ComposeClosing {
    func finishPresentation() {
        chatNavigationController?.dismiss(animated: true, completion: nil)
    }
}
