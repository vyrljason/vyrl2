//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
@testable import Vyrl

final class APIConfigurationMock: APIConfigurationHaving {
    var mainBaseURL = URL(string: "http://test.com")!
    var influencersBaseURL: URL = URL(string: "http://influencers.test.com")!
    var faqURL: URL = URL(string: "http://faq.com")!
    var tosURL: URL = URL(string: "http://tos.com")!
    var mode: ConfigurationMode = .Staging
    var bugReportURL: URL = URL(string: "http://bugreport.com")!
    var shareURL: URL = URL(string: "http://share.com")!
}
