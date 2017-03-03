//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct TableHeaderRenderable {
    var text: String
    var mandatory: Bool
    
    init(text: String = "",
         mandatory: Bool = false) {
        self.text = text
        self.mandatory = mandatory
    }
}
