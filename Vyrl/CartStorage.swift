//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol CartStoring: class {
    func add(item: CartItem)
    func remove(item: CartItem)
    func clear()
    var items: [CartItem] { get }
}

protocol CartUpdateInforming {
    func postUpdate()
}

let cartUpdateNotificationName = Notification.Name("io.govyrl.vyrl.ios.main.brand.dev.cartUpdated")

final class CartStorage: CartStoring, CartUpdateInforming {

    private enum Constants {
        static let defaultsKey: String = "CartStorageCartItems"
        static let accessQueueLabel: String = "SynchronizedCartStorageAccess"
    }

    private let accessQueue = DispatchQueue(label: Constants.accessQueueLabel,
                                            attributes: .concurrent)
    private let objectsStorage: ObjectStoring
    fileprivate let notificationPosting: NotificationPosting

    var items: [CartItem] {
        get {
            var returnValue: [CartItem]!
            accessQueue.sync {
                guard let array = objectsStorage.object(forKey: Constants.defaultsKey) as? [[String : AnyObject]] else {
                    returnValue = []
                    return
                }
                returnValue = array.flatMap({ CartItem(from: $0) })
            }
            return returnValue
        }

        set {
            accessQueue.async(flags: .barrier) {
                let items = newValue.sorted(by: { $0.addedAt > $1.addedAt })
                self.objectsStorage.set(items.map({ $0.storableRepresentation }),
                                        forKey: Constants.defaultsKey)
            }
        }
    }

    init(objectsStorage: ObjectStoring, notificationPosting: NotificationPosting = NotificationCenter.default) {
        self.objectsStorage = objectsStorage
        self.notificationPosting = notificationPosting
    }

    func add(item: CartItem) {
        items += [item]
        postUpdate()
    }

    func remove(item: CartItem) {
        items = items.filter({ return $0 != item })
        postUpdate()
    }

    func clear() {
        items = []
        postUpdate()
    }

    func postUpdate() {
        let update = CountableItemUpdate(itemsCount: items.count)
        notificationPosting.post(name: Notification(name: cartUpdateNotificationName).name, object: nil, userInfo: update.dictionaryRepresentation)
    }
}
