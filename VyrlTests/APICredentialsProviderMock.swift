//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
@testable import Vyrl

final class APICredentialsProviderMock: APICredentialsProviding {
    var userAccessToken: String?
    var didCallClear = false
    
    func clear() {
        didCallClear = true
    }
}
