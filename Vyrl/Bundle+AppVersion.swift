//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension Bundle {
    var applicationVersion: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
