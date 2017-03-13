//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol CustomIntegerConvertible {
    var integerValue: Int { get }
}

extension Array {
    subscript(key: CustomIntegerConvertible) -> Element {
        get {
            return self[key.integerValue]
        }
    }
}
