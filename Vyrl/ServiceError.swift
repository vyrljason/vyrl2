//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case unknown
    case apiResponseError(APIResponseError)
}
