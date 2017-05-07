//
//  PushNotificationResource.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 5/7/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol PushNotificationBehaving {
    func register(token: String, completion: @escaping (Result<Bool, APIResponseError>) -> Void)
}

final class PushNotificationResource: PushNotificationBehaving, APIResource {
    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func register(token: String, completion: @escaping (Result<Bool, APIResponseError>) -> Void) {
        controller.call(endpoint: PushRegistrationEndpoint(deviceToken: token), completion: completion)
    }
}
