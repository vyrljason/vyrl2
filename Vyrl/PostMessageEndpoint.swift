//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

private enum Constants {
    static let pathPrefix = "/chats/"
    static let pathSuffix = "/message"
}

struct PostMessageEndpoint: APIEndpoint {
    let path: String
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = JSONEncoding()

    init(room: String, message: Message) {
        path = Constants.pathPrefix + room + Constants.pathSuffix
        parameters = message.dictionaryRepresentation
    }
}
