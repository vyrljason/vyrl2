//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension Array where Element: DictionaryInitializable {
    init(dictionaries: [[AnyHashable: Any]]?) {
        self = dictionaries?.flatMap { return Element(dictionary: $0) } ?? []
    }
}
