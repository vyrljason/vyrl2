//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] { get }
}

protocol DictionaryInitializable {
    init?(dictionary: [AnyHashable: Any]?)
}
