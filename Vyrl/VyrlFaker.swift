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

    func productVariant(name: String = VyrlFaker.faker.lorem.characters(amount: 20),
                        value: String = VyrlFaker.faker.lorem.characters(amount: 20)) -> ProductVariant {
        return ProductVariant(name: name, value: value)
    }

    func cartItem(productId: String = VyrlFaker.faker.lorem.characters(amount: 20),
                  addedAt: Date = Date(),
                  productVariants: [ProductVariant] = [VyrlFaker.faker.productVariant(), VyrlFaker.faker.productVariant()]) -> CartItem {
        return CartItem(productId: productId, addedAt: addedAt, productVariants: productVariants)
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
    func shippingAddress(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
                         street: String = VyrlFaker.faker.address.streetName(),
                         apartment: String = VyrlFaker.faker.address.buildingNumber(),
                         city: String = VyrlFaker.faker.address.city(),
                         state: String = VyrlFaker.faker.address.state(),
                         zipCode: String = VyrlFaker.faker.address.postcode(),
                         country: String = VyrlFaker.faker.address.county()) -> ShippingAddress {
        return ShippingAddress(id: id,
                               street: street,
                               apartment: apartment,
                               city: city,
                               state: state,
                               zipCode: zipCode,
                               country: country)
    }

    func contactInfo(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
                     email: String = VyrlFaker.faker.internet.email(),
                     phone: String = VyrlFaker.faker.phoneNumber.phoneNumber()) -> ContactInfo {
        return ContactInfo(id: id, email: email, phone: phone)
    }
}

extension Faker {
    func order(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
               brandId: String = VyrlFaker.faker.lorem.characters(amount: 20),
               influencerId: Double = VyrlFaker.faker.number.randomDouble(),
               status: OrderStatus = .requested,
               orderValue: Double = VyrlFaker.faker.number.randomDouble(),
               shippingAddress: ShippingAddress = VyrlFaker.faker.shippingAddress(),
               contactInfo: ContactInfo = VyrlFaker.faker.contactInfo(),
               productList: [Product] = [VyrlFaker.faker.product(), VyrlFaker.faker.product()]) -> Order {
        return Order(id: id,
                     brandId: brandId,
                     influencerId: influencerId,
                     status: status,
                     orderValue: orderValue,
                     shippingAddress: shippingAddress,
                     contactInfo: contactInfo,
                     productList: productList)
    }
}

extension Faker {
    func productImage(id: String = VyrlFaker.faker.lorem.characters(amount: 20),
                      url: URL = URL(string: VyrlFaker.faker.internet.url())!,
                      name: String = VyrlFaker.faker.commerce.productName(),
                      brandId: String = VyrlFaker.faker.lorem.characters(amount: 20)) -> ProductImage {
        return ProductImage(id: id, url: url, name: name, brandId: brandId)
    }
}

extension Faker {
    func collab(brandName: String = VyrlFaker.faker.name.name(),
                authorName: String? = VyrlFaker.faker.name.name(),
                lastMessage: String = VyrlFaker.faker.lorem.characters(amount: 100)) -> Collab {
        return Collab(brandName: brandName, authorName: authorName, lastMessage: lastMessage)
    }
}
