//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import Foundation

final class JSONSerializationMock: JSONSerializationProtocol {
    static var wasCalled: Bool = false
    static var nextData: Data = "{}".data(using: String.Encoding.utf8)!
    static var nextObject: Any = "" as Any
    static var nextError: Error?

    class func dataWithJSONObject(_ obj: Any, options opt: JSONSerialization.WritingOptions) throws -> Data {
        wasCalled = true
        if let error = nextError {
            throw error
        }
        return nextData
    }

    class func JSONObjectWithData(_ data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any {
        wasCalled = true
        if let error = nextError {
            throw error
        }
        return nextObject
    }
    
}
