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
               description: String = VyrlFaker.faker.lorem.sentences(amount: 3),
               submissionsCount: Int = VyrlFaker.faker.number.randomInt(),
               coverImageURL: URL = URL(string: VyrlFaker.faker.internet.url())!) -> Brand {
        return Brand(id: id, name: name, description: description, submissionsCount: submissionsCount, coverImageURL: coverImageURL)
    }
    
    func product(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
                 name: String = VyrlFaker.faker.commerce.productName(),
                 description: String = VyrlFaker.faker.company.catchPhrase(),
                 brandId: String = String(VyrlFaker.faker.number.randomInt()),
                 retailPrice: Double = VyrlFaker.faker.commerce.price()
                 ) -> Product {
        return Product(id: id, name: name, description: description, brandId: brandId, retailPrice: retailPrice, imageUrls: [])
    }
}

extension Internet {
    func url() -> String {
        return "https://\(domainName())/\(username())"
    }
}
