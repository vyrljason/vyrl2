//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Kingfisher

// Service Locator Pattern is used here.
// https://en.wikipedia.org/wiki/Service_locator_pattern

struct ServiceLocator {
    static var imageRetriever: ImageRetrieving = ImageRetrieverAdapter(imageRetriever: KingfisherManager.shared)
    static var resourceConfigurator: APIResourceConfiguring!
    static var cartStorage: CartStoring = CartStorage(objectsStorage: UserDefaults.standard)
    static var chatTokenRepository: ChatTokenRepositoryAdapter!
    static var chatAuthenticator: ChatAuthenticating!
}
