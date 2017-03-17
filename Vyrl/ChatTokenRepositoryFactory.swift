//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ChatTokenRepositoryMaking {
    static func make(using controller: APIResourceControlling) -> ChatTokenRepositoryAdapter
}

enum ChatTokenRepositoryFactory: ChatTokenRepositoryMaking {
    static func make(using controller: APIResourceControlling) -> ChatTokenRepositoryAdapter {
        let storedRepository = ChatTokenResource(controller: controller)
        return ChatTokenRepositoryAdapter(repository: StoredRepository<ChatTokenResource>(source: storedRepository))
    }
}
