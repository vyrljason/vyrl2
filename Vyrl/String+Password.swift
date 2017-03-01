//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension String {
    var isValidPassword: Bool {
        let regex = "^(?=.*[A-Z])(?=.*[0-9])[\\S]{6,144}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
}
