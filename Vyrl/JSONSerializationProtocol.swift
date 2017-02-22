//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol JSONSerializationProtocol {
    static func dataWithJSONObject(_ obj: Any, options opt: JSONSerialization.WritingOptions) throws -> Data
    static func JSONObjectWithData(_ data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any
}

extension JSONSerialization : JSONSerializationProtocol { }
