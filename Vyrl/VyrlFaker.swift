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
               coverImageURL: URL? = URL(string: VyrlFaker.faker.internet.url())) -> Brand {
        return Brand(id: id, name: name, description: description, submissionsCount: submissionsCount, coverImageURL: coverImageURL)
    }

    func product(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
                 name: String = VyrlFaker.faker.commerce.productName(),
                 description: String = VyrlFaker.faker.company.catchPhrase(),
                 category: String = VyrlFaker.faker.lorem.characters(amount: 20),
                 brandId: String = String(VyrlFaker.faker.number.randomInt()),
                 retailPrice: Double = VyrlFaker.faker.commerce.price(),
                 isAdditionalGuidelines: Bool = false,
                 additionalGuidelines: String = VyrlFaker.faker.lorem.characters(amount: 200),
                 images: [ProductImage] = [],
                 variants: [ProductVariants] = []) -> Product {
        return Product(id: id,
                       name: name,
                       description: description,
                       category: category,
                       brandId: brandId,
                       retailPrice: retailPrice,
                       isAdditionalGuidelines: isAdditionalGuidelines,
                       additionalGuidelines: additionalGuidelines,
                       images: images,
                       variants: variants)
    }

    func cartItem(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
                  addedAt: Date = Date()) -> CartItem {
        return CartItem(id: id, addedAt: addedAt)
    }
}

extension Internet {
    func url() -> String {
        return "https://\(domainName())/\(username())"
    }
}

extension Faker {
    func category(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
                  name: String = VyrlFaker.faker.company.catchPhrase()) -> Category {
        return Category(id: id, name: name)
    }
}

extension Faker {
    func userSettings(id: Int = VyrlFaker.faker.number.randomInt(),
                      user: Int = VyrlFaker.faker.number.randomInt(),
                      isAdmin: Bool = false,
                      isBrand: Bool = false,
                      isInfluencer: Bool = false,
                      brandRequestClosed: Bool = false,
                      brandStatusRequested: Bool = false,
                      chatRequestsEnabled: Bool = false,
                      emailNotificationsEnabled: Bool = false,
                      pushNotificationsenabled: Bool = false) -> UserSettings {
        return UserSettings(id: id,
                            user: user,
                            isAdmin: isAdmin,
                            isBrand: isBrand,
                            isInfluencer: isInfluencer,
                            brandRequestClosed: brandRequestClosed,
                            brandStatusRequested: brandStatusRequested,
                            chatRequestsEnabled: chatRequestsEnabled,
                            emailNotificationsEnabled: emailNotificationsEnabled,
                            pushNotificationsEnabled: pushNotificationsenabled)
    }

    func socialNetworkProfile(username: String = VyrlFaker.faker.company.name()) -> SocialNetworkProfile {
        return SocialNetworkProfile(username: username)
    }

    func userProfile(id: Int = VyrlFaker.faker.number.randomInt(),
                     avatar: URL = URL(string: VyrlFaker.faker.internet.url())!,
                     bio: String = VyrlFaker.faker.lorem.characters(amount: 20),
                     discoveryFeedImage: URL = URL(string: VyrlFaker.faker.internet.url())!,
                     email: String = VyrlFaker.faker.internet.email(),
                     fullName: String = VyrlFaker.faker.company.name(),
                     pendingEmail: String = VyrlFaker.faker.internet.email(),
                     isPlatformConfirmed: Bool = false,
                     tagline: String = VyrlFaker.faker.lorem.characters(amount: 20),
                     token: String = VyrlFaker.faker.lorem.characters(amount: 20),
                     username: String = VyrlFaker.faker.company.name(),
                     settings: UserSettings = VyrlFaker.faker.userSettings(),
                     instagramProfile: SocialNetworkProfile = VyrlFaker.faker.socialNetworkProfile(),
                     industries: [Industry] = []) -> UserProfile {
        return UserProfile(id: id,
                           avatar: avatar,
                           bio: bio,
                           discoveryFeedImage: discoveryFeedImage,
                           email: email, fullName: fullName,
                           pendingEmail: pendingEmail,
                           isPlatformConfirmed: isPlatformConfirmed,
                           tagline: tagline,
                           token: token,
                           username: username,
                           settings: settings,
                           instagramProfile: instagramProfile,
                           industries: industries)
    }
}

extension Faker {
    func shippingAddress(street: String = VyrlFaker.faker.address.streetName(),
                         apartment: String = VyrlFaker.faker.address.buildingNumber(),
                         city: String = VyrlFaker.faker.address.city(),
                         state: String = VyrlFaker.faker.address.state(),
                         zipCode: String = VyrlFaker.faker.address.postcode(),
                         country: String = VyrlFaker.faker.address.county()) -> ShippingAddress {
        return ShippingAddress(street: street,
                               apartment: apartment,
                               city: city,
                               state: state,
                               zipCode: zipCode,
                               country: country)
    }
}
