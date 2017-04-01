//
//  WelcomeViewController.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/1/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController, HavingNib {
    static let nibName: String = "WelcomeViewController"
    
    private let interactor: WelcomeViewInteracting

    init(interactor: WelcomeViewInteracting) {
        self.interactor = interactor
        super.init(nibName: WelcomeViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let form = formFactory.make(fields: [username, email])
//        interactor.didPrepare(form: form)
    }
    
    @IBAction private func didTapSubmit() {
//        interactor.didTapSubmit()
    }
}
