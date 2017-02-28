//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

final class VyrlServerTrustPolicyManager: ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        let policy = ServerTrustPolicy.pinCertificates(certificates: ServerTrustPolicy.certificates(in: Bundle.main),
                                                       validateCertificateChain: true,
                                                       validateHost: true)
        return policy
    }
}
