//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let invalidPasswordApiMessage = "Incorrect password"
    static let invalidUsernameApiMessage = "Not Found: \"user\""
}

enum LoginError: Error {
    case invalidPassword
    case invalidUsername
    case unknown

    var message: String {
        switch self {
        case .invalidPassword: return NSLocalizedString("login.error.invalidPassword.message", comment: "")
        case .invalidUsername: return NSLocalizedString("login.error.invalidUsername.message", comment: "")
        case .unknown: return NSLocalizedString("login.error.unknown.message", comment: "")
        }
    }

    var title: String {
        return NSLocalizedString("login.error.title", comment: "")
    }

    init(apiError: APIError) {
        switch apiError.message {
        case let message where message.contains(Constants.invalidPasswordApiMessage):
            self = .invalidPassword
        case let message where message.contains(Constants.invalidUsernameApiMessage):
            self = .invalidUsername
        default:
            self = .unknown
        }
    }
}

protocol UserLoginProviding {
    func login(using credentials: UserCredentials, completion: @escaping (Result<UserProfile, LoginError>) -> Void)
}

final class LoginService: UserLoginProviding {

    private let resource: AuthorizingWithCredentials

    init(resource: AuthorizingWithCredentials) {
        self.resource = resource
    }

    func login(using credentials: UserCredentials, completion: @escaping (Result<UserProfile, LoginError>) -> Void) {
        resource.login(using: credentials) { result in
            completion(result.map(success: { .success($0) }, failure: { error in
                guard case .apiRequestError(let apiError) = error else { return .failure(.unknown) }
                return .failure(LoginError(apiError: apiError))
            }))
        }
    }
}
