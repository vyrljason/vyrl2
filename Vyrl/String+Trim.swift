//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension String {
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
