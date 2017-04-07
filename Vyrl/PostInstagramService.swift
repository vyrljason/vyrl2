//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UpdatePostWithInstagram {
    func update(brandId: String, withInstagram instagramUrl: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void)
}

final class InstagramUpdateService: UpdatePostWithInstagram {
    private let resource: PostService<PostInstagramResource>

    init(resource: PostService<PostInstagramResource>) {
        self.resource = resource
    }

    func update(brandId: String, withInstagram instagramUrl: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        resource.post(using: InstagramPost(brandId: brandId, instagramUrl: instagramUrl), completion: completion)
    }
}
