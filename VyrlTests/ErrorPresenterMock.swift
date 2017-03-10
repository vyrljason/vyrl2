//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
@testable import Vyrl

final class ErrorPresenterMock: ErrorAlertPresenting {
    var didPresentError = false

    func presentError(title: String?, message: String?) {
        didPresentError = true
    }
}
