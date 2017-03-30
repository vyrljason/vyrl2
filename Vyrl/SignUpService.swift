//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    //TODO: Change to all possible sign up errors
    static let invalidPasswordApiMessage = "Incorrect password"
    static let invalidUsernameApiMessage = "Not Found: \"user\""
}

enum SignUpError: Error {
    case invalidPassword
    case invalidUsername
    case unknown

    //TODO: Change to all possible sign up errors and map to proper localizable strings
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

protocol UserSignUpProviding {
    func signUp(using request: UserSignUpRequest, completion: @escaping (Result<UserProfile, SignUpError>) -> Void)
}

final class SignUpService: UserSignUpProviding {

    private let resource: SigningUpWithCredentials

    init(resource: SigningUpWithCredentials) {
        self.resource = resource
    }

    func signUp(using request: UserSignUpRequest, completion: @escaping (Result<UserProfile, SignUpError>) -> Void) {
        resource.signUp(using: request) { result in
            completion(result.map(success: { .success($0) }, failure: { error in
                guard case .apiRequestError(let apiError) = error else { return .failure(.unknown) }
                return .failure(SignUpError(apiError: apiError))
            }))
        }
    }
}
