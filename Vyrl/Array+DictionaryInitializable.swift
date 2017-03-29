//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension Array where Element: DictionaryInitializable {
    init(dictionaries: [AnyHashable: [AnyHashable: Any]]?) {
        self = dictionaries?.values.flatMap { return Element(dictionary: $0) } ?? []
    }
}
