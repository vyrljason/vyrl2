//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ActionButtonState {
    case disabled
    case inProgress
    case enabled
}

struct ActionButtonRenderable {

    var isEnabled: Bool
    var isActivityIndicatorVisible: Bool

    init(state: ActionButtonState) {
        isEnabled = state != .disabled
        isActivityIndicatorVisible = state == .inProgress
    }
}
