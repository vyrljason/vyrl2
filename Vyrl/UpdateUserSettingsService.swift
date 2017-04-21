//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UserSettingsUpdating {
    func update(userSettings: UserSettings, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void)
}

final class UpdateUserSettingsService: UserSettingsUpdating {
    private let resource: PostService<UpdateUserSettingsResource>
    
    init(resource: PostService<UpdateUserSettingsResource>) {
        self.resource = resource
    }
    
    func update(userSettings: UserSettings, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        resource.post(using: userSettings, completion: completion)
    }
}
