//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UpdatePostWithInstagram {
    func update(postId: String, withInstagram instagramUrl: String, completion: @escaping (Result<InfluencerPost, ServiceError>) -> Void)
}

final class InstagramUpdateService: UpdatePostWithInstagram {
    private let resource: PostService<PostInstagramResource>

    init(resource: PostService<PostInstagramResource>) {
        self.resource = resource
    }

    func update(postId: String, withInstagram instagramUrl: String, completion: @escaping (Result<InfluencerPost, ServiceError>) -> Void) {
        resource.post(using: InstagramPost(postId: postId, instagramUrl: instagramUrl), completion: completion)
    }
}
