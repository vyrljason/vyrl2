//
//  MessagesViewControllerFactory.swift
//  Vyrl
//
//  Created by Wojciech Stasiński on 20/03/2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController
}

final class MessagesViewControllerFactory: MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController {
        let dataSource = MessagesDataSource()
        let interactor = MessagesInteractor(dataSource: dataSource, collab: collab)
        let viewController = MessagesViewController(interactor: interactor)
        viewController.navigationItem.title = collab.brandName
        return viewController
    }
}
