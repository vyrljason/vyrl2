//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ChatSigningInMock: ChatSigningIn {

    var success = true
    var error: NSError = FirebaseError.failedAuthorization.error

    func signIn(withCustomToken token: String, completion: @escaping ((Result<Void, NSError>) -> Void)) {
        if success {
            completion(.success())
        } else {
            completion(.failure(error))
        }

    }
}

final class ChatDecodingMock: ChatTokenDecoding {
    var success = true
    var userId = InternalUserId(id: "id")
    var token: String?

    func decodeJWT(using token: String) -> InternalUserId? {
        self.token = token
        return success ? userId : nil
    }
}

final class ChatTokenRepositoryMock: ChatTokenProviding {

    var success = true
    var token: ChatToken = ChatToken(token: "token")
    var error: ServiceError = .unknown

    func getChatToken(refresh: Bool, completion: @escaping (Result<ChatToken, ServiceError>) -> Void) {
        if success {
            completion(.success(token))
        } else {
            completion(.failure(error))
        }
    }
}

final class ChatAuthenticatorTest: XCTestCase {

    private var subject: ChatAuthenticator!
    private var chatCredentialsStorage: ChatCredentialsStorageMock!
    private var chatTokenRepository: ChatTokenRepositoryMock!
    private var authenticator: ChatSigningInMock!
    private var tokenDecoder: ChatDecodingMock!

    override func setUp() {
        super.setUp()

        chatCredentialsStorage = ChatCredentialsStorageMock()
        chatTokenRepository = ChatTokenRepositoryMock()
        authenticator = ChatSigningInMock()
        tokenDecoder = ChatDecodingMock()
        subject = ChatAuthenticator(chatTokenRepository: chatTokenRepository,
                                    authenticator: authenticator,
                                    tokenDecoder: tokenDecoder,
                                    chatCredentialsStorage: chatCredentialsStorage)
    }

    func test_authenticateUser_whenChatRepositoryAndAuthenticatorSuccess_returnSuccess() {
        chatTokenRepository.success = true
        authenticator.success = true

        subject.authenticateUser { result in
            expectToBeSuccess(result)
        }
    }

    func test_authenticateUser_whenChatRepositoryFailsAuthenticatorSuccess_returnFailure() {
        chatTokenRepository.success = false
        authenticator.success = true

        subject.authenticateUser { result in
            expectToBeFailure(result)

        }
    }

    func test_authenticateUser_whenChatRepositorySuccessAuthenticatorFails_returnFailure() {
        chatTokenRepository.success = true
        authenticator.success = false

        subject.authenticateUser { result in
            expectToBeFailure(result)
        }
    }

    func test_authenticateUser_whenChatRepositorySuccess_decodesUserId() {
        chatTokenRepository.success = true
        authenticator.success = true

        subject.authenticateUser { _ in }

        XCTAssertEqual(chatTokenRepository.token.token, tokenDecoder.token)
    }

}
