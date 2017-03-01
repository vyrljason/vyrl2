//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ObjectStoring {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

extension UserDefaults: ObjectStoring { }
