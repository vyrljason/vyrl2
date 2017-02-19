//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class LeftMenuViewController: UIViewController, HavingNib {
    
    static let nibName: String = "LeftMenuViewController"

    private let interactor: LeftMenuInteracting

    @IBOutlet private var homeButton: UIButton!

    init(interactor: LeftMenuInteracting) {
        self.interactor = interactor
        super.init(nibName: LeftMenuViewController.nibName, bundle: nil)
    }

    override func viewDidLoad() {
        homeButton.addTarget(interactor, action: #selector(LeftMenuInteracting.didTapHome), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
