//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class VyrlFaker {
    static let faker = Faker()
}

extension Faker {
    func brand(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
               name: String = VyrlFaker.faker.company.name(),
               submissionsCount: Int = VyrlFaker.faker.number.randomInt(),
               coverImageURL: URL = URL(string: VyrlFaker.faker.internet.url())!) -> Brand {
        return Brand(id: id, name: name, submissionsCount: submissionsCount, coverImageURL: coverImageURL)
    }
}
