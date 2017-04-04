//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ChatAuthenticationError: Error {
    case noChatToken
    case signInProblem(NSError)

    var message: String {
        switch self {
        case .noChatToken: return NSLocalizedString("chat.login.error.message", comment: "")
        case .signInProblem(let error): return error.localizedDescription
        }
    }

    var title: String {
        return NSLocalizedString("chat.login.error.title", comment: "")
    }
}

protocol ChatAuthenticating {
    func authenticateUser(completion: @escaping ((Result<Void, ChatAuthenticationError>) -> Void))
}

final class ChatAuthenticator: ChatAuthenticating {

    private let chatTokenRepository: ChatTokenProviding
    private let authenticator: ChatSigningIn
    private let tokenDecoder: ChatTokenDecoding
    private let chatCredentialsStorage: ChatCredentialsStoring
    private let unreadMessagesObserver: UnreadMessagesObserving

    init(chatTokenRepository: ChatTokenProviding,
         authenticator: ChatSigningIn,
         tokenDecoder: ChatTokenDecoding,
         chatCredentialsStorage: ChatCredentialsStoring,
         unreadMessagesObserver: UnreadMessagesObserving) {
        self.chatTokenRepository = chatTokenRepository
        self.authenticator = authenticator
        self.tokenDecoder = tokenDecoder
        self.chatCredentialsStorage = chatCredentialsStorage
        self.unreadMessagesObserver = unreadMessagesObserver
    }

    func authenticateUser(completion: @escaping ((Result<Void, ChatAuthenticationError>) -> Void)) {
        chatTokenRepository.getChatToken(refresh: true) { [weak self] result in
            result.on(success: { [weak self] chatToken in
                guard let `self` = self else { return }
                self.saveUserId(using: chatToken)
                self.authenticator.signIn(withCustomToken: chatToken.token) { result in
                    switch result {
                    case .success:
                        self.unreadMessagesObserver.observeUnreadMessages()
                        completion(.success())
                    case .failure(let error):
                        completion(.failure(.signInProblem(error)))
                    }
                }
                }, failure: { _ in completion(.failure(.noChatToken))
            })
        }
    }

    private func saveUserId(using chatToken: ChatToken) {
        let userId = tokenDecoder.decodeJWT(using: chatToken.token)
        chatCredentialsStorage.internalUserId = userId?.id
    }
}
