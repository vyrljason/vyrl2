//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ConfirmingDelivery {
    func confirmDelivery(forBrand brandId: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void)
}

final class ConfirmDeliveryService: ConfirmingDelivery {
    private let resource: PostService<ConfirmDeliveryResource>

    init(resource: PostService<ConfirmDeliveryResource>) {
        self.resource = resource
    }

    func confirmDelivery(forBrand brandId: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        resource.post(using: ConfirmDeliveryRequest(brandId: brandId), completion: completion)
    }
}
