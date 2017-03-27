//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ChatAuthenticationError: Error {
    case noChatToken
    case signInProblem(NSError)
}

protocol ChatAuthenticating {
    func authenticateUser(completion: @escaping ((Result<Void, ChatAuthenticationError>) -> Void))
}

final class ChatAuthenticator: ChatAuthenticating {

    private let chatTokenRepository: ChatTokenProviding
    private let authenticator: ChatSigningIn
    private let tokenDecoder: ChatTokenDecoding
    private let chatCredentialsStorage: ChatCredentialsStoring

    init(chatTokenRepository: ChatTokenProviding,
         authenticator: ChatSigningIn,
         tokenDecoder: ChatTokenDecoding,
         chatCredentialsStorage: ChatCredentialsStoring) {
        self.chatTokenRepository = chatTokenRepository
        self.authenticator = authenticator
        self.tokenDecoder = tokenDecoder
        self.chatCredentialsStorage = chatCredentialsStorage
    }

    func authenticateUser(completion: @escaping ((Result<Void, ChatAuthenticationError>) -> Void)) {
        chatTokenRepository.getChatToken(refresh: false) { [weak self] result in
            result.on(success: { [weak self] token in
                guard let `self` = self else { return }
                self.saveUserId(using: token)
                self.authenticator.signIn(withCustomToken: token.token) { result in
                    switch result {
                    case .success:
                        completion(.success())
                    case .failure(let error):
                        completion(.failure(.signInProblem(error)))
                    }
                }
                }, failure: { _ in completion(.failure(.noChatToken))
            })
        }
    }

    private func saveUserId(using token: ChatToken) {
        let userId = tokenDecoder.decodeJWT(using: token.token)
        chatCredentialsStorage.internalUserId = userId?.id
    }
}
