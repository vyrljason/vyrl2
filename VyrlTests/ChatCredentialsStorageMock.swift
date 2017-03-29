//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import Foundation

final class ChatCredentialsStorageMock: ChatCredentialsStoring {
    var chatToken: String?
    var internalUserId: String?
}
