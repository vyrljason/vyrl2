//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Firebase
import FirebaseAuth

enum FirebaseError: Int, CustomIntegerConvertible {
    case failedAuthorization = 9000

    var integerValue: Int {
        return rawValue
    }

    static var errorDomain: String {
        return "io.govyrl.vyrl.firebase"
    }
}

protocol ChatSigningIn {
    func signIn(withCustomToken token: String, completion: @escaping ((Result<Void, NSError>) -> Void))
}

extension FIRAuth: ChatSigningIn {
    func signIn(withCustomToken token: String,
                completion: @escaping ((Result<Void, NSError>) -> Void)) {
        signIn(withCustomToken: token) { (user, error) in
            if let _ = user {
                completion(.success())
            } else if let error = error as? NSError {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: FirebaseError.errorDomain, code: FirebaseError.failedAuthorization.integerValue, userInfo: nil)))
            }
        }
    }
}
