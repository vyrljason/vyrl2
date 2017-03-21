//
//  MessagesViewControllerFactory.swift
//  Vyrl
//
//  Created by Wojciech Stasiński on 20/03/2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let messagesNavigationTitle = NSLocalizedString("messages.navigation.title", comment: "")
}

protocol MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController
}

final class MessagesViewControllerFactory: MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController {
        let interactor = MessagesInteractor()
        let viewController = MessagesViewController(interactor: interactor)
        viewController.navigationItem.title = Constants.messagesNavigationTitle
        return viewController
    }
}
