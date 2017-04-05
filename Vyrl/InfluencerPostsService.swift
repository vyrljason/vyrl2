//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol InfluencerPostsProviding {
    func influencerPosts(fromBrand brandId: String, completion: @escaping (Result<InfluencerPosts, ServiceError>) -> Void)
}

final class InfluencerPostsService: InfluencerPostsProviding {
    private let resource: PostService<InfluencerPostsResource>

    init(resource: PostService<InfluencerPostsResource>) {
        self.resource = resource
    }

    func influencerPosts(fromBrand brandId: String, completion: @escaping (Result<InfluencerPosts, ServiceError>) -> Void) {
        resource.post(using: InfluencerPostsRequest(brandId: brandId), completion: completion)
    }
}
