//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct DetailTableCellRenderable {
    var text: String
    var detail: String
    var mandatory: Bool
    
    init(text: String = "",
        detail: String = "",
        mandatory: Bool = false) {
        self.text = text
        self.detail = detail
        self.mandatory = mandatory
    }
}
