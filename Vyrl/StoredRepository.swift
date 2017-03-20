//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import KeychainAccess

protocol RepositorySource: class {
    associatedtype ResponseType: CustomStringConvertible
    var storageKey: KeychainKey { get }
    func fetch(completion: @escaping (Result<ResponseType, APIResponseError>) -> Void)
}

final class StoredRepository<Source: RepositorySource> {

    private let isFetchingAccessQueue = DispatchQueue(label: "io.govyrl.vyrl.ios.main.brand.dev-" + NSUUID().uuidString)
    private let callbacksAccessQueue = DispatchQueue(label: "io.govyrl.vyrl.ios.main.brand.dev-" + NSUUID().uuidString)

    private var _awaitingCallbacks: [((Result<String, APIResponseError>) -> Void)] = []
    private var awaitingCallbacks: [((Result<String, APIResponseError>) -> Void)] {
        get {
            var result = [((Result<String, APIResponseError>) -> Void)]()
            callbacksAccessQueue.sync {
                result = self._awaitingCallbacks
            }
            return result
        }
        set {
            callbacksAccessQueue.async(flags: .barrier) {
                self._awaitingCallbacks = newValue
            }
        }
    }

    private var _isFetching: Bool = false
    private var isFetching: Bool {
        get {
            var result = false
            isFetchingAccessQueue.sync {
                result = self._isFetching
            }
            return result
        }
        set {
            isFetchingAccessQueue.async(flags: .barrier) {
                self._isFetching = newValue
            }
        }
    }

    private let source: Source
    private let secureStorage: KeychainProtocol

    init(source: Source, secureStorage: KeychainProtocol = Keychain(service: KeychainConstants.serviceName)) {
        self.secureStorage = secureStorage
        self.source = source
    }

    func fetch(refresh: Bool, callback: @escaping (Result<String, APIResponseError>) -> Void) {
        if let data = secureStorage[source.storageKey], !refresh {
            callback(.success(data))
            return
        }

        awaitingCallbacks.append(callback)

        guard !isFetching else { return }
        isFetching = true

        source.fetch { [weak self] response in
            guard let `self` = self else { return }

            if case .success(let data) = response {
                self.secureStorage[self.source.storageKey] = data.description
            }

            self.triggerCallbacks(response: response.map(success: { .success($0.description) },
                                                         failure: { .failure($0) }))
            self.isFetching = false
        }
    }

    private func triggerCallbacks(response: Result<String, APIResponseError>) {
        awaitingCallbacks.forEach { $0(response) }
        awaitingCallbacks.removeAll()
    }

    func purgeStoredData() {
        secureStorage[source.storageKey] = nil
    }
}
