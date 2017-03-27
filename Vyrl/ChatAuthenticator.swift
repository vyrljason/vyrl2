//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ChatAuthenticating {
    func authenticateUser()
}

final class ChatAuthenticator: ChatAuthenticating {

    private let chatTokenRepository: ChatTokenProviding
    private let authenticator: ChatSigningIn

    init(chatTokenRepository: ChatTokenProviding,
         authenticator: ChatSigningIn) {
        self.chatTokenRepository = chatTokenRepository
        self.authenticator = authenticator
    }

    func authenticateUser() {
        chatTokenRepository.getChatToken(refresh: false) { [weak self] result in
            result.on(success: { [weak self] token in
                guard let `self` = self else { return }
                self.authenticator.signIn(withCustomToken: token.token) { result in
                    switch result {
                    case .success: ()
                    case .failure(_): ()
                    }
                }
            })
        }
    }
}
