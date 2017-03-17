//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct CollabRenderable {
    let name: String
    let lastMessage: String

    init(collab: Collab) {
        name = collab.brandName
        lastMessage = collab.lastMessage
    }
}
