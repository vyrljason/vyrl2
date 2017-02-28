//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
@testable import Vyrl

final class APIConfigurationMock: APIConfigurationHaving {
    var mainBaseURL = URL(string: "http://test.com")!
    var influencersBaseURL: URL = URL(string: "http://influencers.test.com")!
    var mode: ConfigurationMode = .Staging
}
