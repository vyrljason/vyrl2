//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol StorageItemProtocol {
    init?(from dictionary: [String : AnyObject])
    var storableRepresentation: [String: AnyObject] { get }
}
struct CartItem {

    let productId: String
    let productVariants: [ProductVariant]
    let addedAt: Date

    init(productId: String, addedAt: Date, productVariants: [ProductVariant]) {
        self.productId = productId
        self.addedAt = addedAt
        self.productVariants = productVariants
    }
}

extension CartItem: DictionaryConvertible {

    private enum JSONKeys {
        static let id: String = "id"
        static let variants: String = "variants"
    }
    var dictionaryRepresentation: [String: Any] {
        let variantsAsDictionaries: [[String: Any]] = productVariants.map { $0.dictionaryRepresentation }
        return [JSONKeys.id: productId,
                JSONKeys.variants: variantsAsDictionaries]
    }
}

extension CartItem: StorageItemProtocol {
    private enum Constants {
        static let idKey: String = "CartItem.id"
        static let addedAtKey: String = "CartItem.addedAt"
        static let variantsKey: String = "CartItem.variants"
    }

    init?(from dictionary: [String : AnyObject]) {
        guard let productId = dictionary[Constants.idKey] as? String,
            let addedAt = dictionary[Constants.addedAtKey] as? Date,
            let productVariants = dictionary[Constants.variantsKey] as? [[String: AnyObject]] else {
                return nil
        }

        self.productId = productId
        self.addedAt = addedAt
        self.productVariants = productVariants.flatMap { ProductVariant(from: $0) }
    }

    var storableRepresentation: [String : AnyObject] {
        let variantsAsDictionaries: [[String: AnyObject]] = productVariants.flatMap { $0.dictionaryRepresentation as [String: AnyObject] }
        var dictionary: Dictionary = [String: AnyObject]()
        dictionary[Constants.idKey] = productId as AnyObject?
        dictionary[Constants.addedAtKey] = addedAt as AnyObject?
        dictionary[Constants.variantsKey] = variantsAsDictionaries as AnyObject?
        return dictionary
    }
}

extension CartItem: Equatable {
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.productId == rhs.productId && lhs.addedAt == rhs.addedAt
    }
}
