//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

func += <Key: Hashable, Value>(lhs: inout [Key: Value]?, rhs: [Key: Value]) {
    if lhs == nil {
        lhs = [Key: Value]()
    }
    for (key, value) in rhs {
        lhs?[key] = value
    }
}

func += <Key: Hashable, Value>(lhs: inout [Key: Value], rhs: [Key: Value]) {
    for (key, value) in rhs {
        lhs[key] = value
    } 
}
