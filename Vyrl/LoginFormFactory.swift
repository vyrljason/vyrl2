//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol LoginFormMaking {
    static func make(username: UITextField, password: UITextField) -> LoginFormInteracting
}

enum LoginFormFactory: LoginFormMaking {

    static func make(username: UITextField, password: UITextField) -> LoginFormInteracting {
        let username = FormItem(field: .vyrlUsername, textField: username)
        let password = FormItem(field: .password, textField: password)
        return LoginFormInteractor(username: username, password: password)
    }
}
