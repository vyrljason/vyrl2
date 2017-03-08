//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct ExpandableTextTableCellRenderable {
    var text: String
    var initiallyExpanded: Bool
    
    init(text: String = "",
         initiallyExpanded: Bool = false) {
        self.text = text
        self.initiallyExpanded = initiallyExpanded
    }
}
