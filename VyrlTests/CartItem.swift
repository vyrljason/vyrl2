//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct CartItem: DictionaryConvertible {

    private enum Constants {
        static let idKey: String = "CartItem.id"
        static let addedAtKey: String = "CartItem.addedAt"
    }

    let id: String
    let addedAt: Date

    init(id: String, addedAt: Date) {
        self.id = id
        self.addedAt = addedAt
    }

    init?(from dictionary: [String : Any]) {
        guard let id = dictionary[Constants.idKey] as? String,
            let addedAt = dictionary[Constants.addedAtKey] as? Date else {
                return nil
        }

        self.id = id
        self.addedAt = addedAt
    }

    var dictionaryRepresentation: [String : Any] {
        var dictionary: Dictionary = [String : AnyObject]()
        dictionary[Constants.idKey] = id as AnyObject?
        dictionary[Constants.addedAtKey] = addedAt as AnyObject?
        return dictionary
    }
}

extension CartItem: Equatable {
    static func ==(lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.id == rhs.id && lhs.addedAt == rhs.addedAt
    }
}
