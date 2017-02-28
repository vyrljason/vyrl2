//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct CartItem {

    private enum Constants {
        static let idKey: String = "CartItem.id"
        static let addedAtKey: String = "CartItem.addedAt"
    }

    let id: String
    let addedAt: Date

    public init(id: String, addedAt: Date) {
        self.id = id
        self.addedAt = addedAt
    }

    public init?(from dictionary: [String : AnyObject]) {
        guard let id = dictionary[Constants.idKey] as? String,
            let addedAt = dictionary[Constants.addedAtKey] as? Date else {
                return nil
        }

        self.id = id
        self.addedAt = addedAt
    }

    var dictionaryRepresentation: [String : AnyObject] {
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
