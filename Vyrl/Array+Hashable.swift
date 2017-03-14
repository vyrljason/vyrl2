//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var customHashValue: Int {
        return self.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1.hashValue)
        }
    }
}

func == <Key: Hashable, Value: Equatable>(lhs: [[Key: Value]], rhs: [[Key: Value]]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for i in 0..<lhs.count {
        if lhs[i] != rhs[i] { return false }
    }
    return true
}
