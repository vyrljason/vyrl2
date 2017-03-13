//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension String {
    var isEmail: Bool {
        let emailRegularExpression = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegularExpression)
        return emailTest.evaluate(with: self)
    }
}
