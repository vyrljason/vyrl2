//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ChatNavigating {
    weak var chatNavigationController: UINavigationController? { get set }
    var collabs: CollabsViewController! { get }
}

final class ChatNavigationBuilder {
    var collabsFactory: CollabsControllerMaking.Type = CollabsViewControllerFactory.self
    
    func build() -> ChatNavigating {
        return ChatNavigation(collabsFactory: collabsFactory)
    }
}

final class ChatNavigation: ChatNavigating {
    weak var chatNavigationController: UINavigationController?
    var collabs: CollabsViewController!
    fileprivate let collabsFactory: CollabsControllerMaking.Type
    
    init (collabsFactory: CollabsControllerMaking.Type) {
        self.collabsFactory = collabsFactory
        collabs = collabsFactory.make(chatNavigation: self)
    }
}
