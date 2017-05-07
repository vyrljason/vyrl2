//
//  PushRegistrationEndpoint.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 5/7/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct PushRegistrationEndpoint: APIEndpoint {
    let path = "/noti/register"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = JSONEncoding()
    
    init(deviceToken: String) {
        parameters = [
            "deviceToken": deviceToken,
            "platform": "ios"
        ]
    }

}
