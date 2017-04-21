//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

final class UpdateUserSettingsResource: PostingWithParameters, APIResource {
    
    typealias ResponseModel = EmptyResponse
    typealias Parameters = UserSettings
    private let controller: APIResourceControlling
    
    init(controller: APIResourceControlling) {
        self.controller = controller
    }
    
    func post(using parameters: UserSettings, completion: @escaping (Result<EmptyResponse, APIResponseError>) -> Void) {
        controller.call(endpoint: UpdateUserSettingsEndpoint(userSettings: parameters), completion: completion)
    }
}
