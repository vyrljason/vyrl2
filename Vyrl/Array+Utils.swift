//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func after(item: Element) -> Element? {
        if let index = index(of: item), index + 1 < count {
            return self[index + 1]
        }
        return nil
    }
}
