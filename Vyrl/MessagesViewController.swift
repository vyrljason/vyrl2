//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class MessagesViewController: UIViewController, HavingNib {
    static var nibName: String = "MessagesViewController"

    fileprivate var interactor: MessagesInteracting
    
    init(interactor: MessagesInteracting) {
        self.interactor = interactor
        super.init(nibName: MessagesViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor.viewWillAppear()
    }
}
