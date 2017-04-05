//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum CollabStatus: Int, CustomStringConvertible, CustomIntegerConvertible {

    private enum Constants {
        static let currentStatusTitle = NSLocalizedString("messages.currentStatus.title", comment: "")
        static let fontSize: CGFloat = 16
    }

    case brief = 0
    case productDelivery = 1
    case contentReview = 2
    case publication = 3
    case done = 4
    case waiting = -1
    case declined = -2
    case inactive = -3

    // swiftlint:disable cyclomatic_complexity
    init(orderStatus: OrderStatus, contentStatus: ContentStatus) {
        switch (orderStatus, contentStatus) {
        case (.custom(_), .none):
            self = .inactive
        case (.accepted, .none):
            self = .brief
        case (.declined, .none):
            self = .declined
        case (.shipped, .none):
            self = .productDelivery
        case (.delivered, .none),
             (.delivered, .pending),
             (.delivered, .declined):
            self = .contentReview
        case (.delivered, .approved):
            self = .publication
        case (.posted, .approved):
            self = .done
        default:
            self = .inactive
        }
    }

    static var allValidStatuses: [CollabStatus] {
        return [CollabStatus.brief, CollabStatus.productDelivery, CollabStatus.contentReview,
                CollabStatus.publication, CollabStatus.done]
    }

    var description: String {
        switch self {
        case .brief:
            return "1. brief"
        case .productDelivery:
            return "2. productDelivery"
        case .contentReview:
            return "3. contentReview"
        case .publication:
            return "4. publication"
        case .done:
            return "5. done"
        case .waiting:
            return "Waiting for brand response..."
        case .declined:
            return "Declined"
        case .inactive:
            return "No active collab"
        }
    }

    var integerValue: Int {
        return self.rawValue
    }

    var isValid: Bool {
        switch self {
        case .waiting:
            return false
        default:
            return true
        }
    }

    var attributedText: NSAttributedString {
        return NSAttributedString(string: description)
    }

    var boldAttributedText: NSAttributedString {
        return NSAttributedString(string: description,
                                  attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: Constants.fontSize)])
    }

    var strikedAttributedText: NSAttributedString {
        return NSAttributedString(string: description,
                                  attributes: [NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),
                                                                         NSForegroundColorAttributeName: UIColor.warmGrey])
    }

    var lightAttributedText: NSAttributedString {
        return NSAttributedString(string: description,
                                  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: Constants.fontSize, weight: UIFontWeightLight),
                                                                         NSForegroundColorAttributeName: UIColor.warmGrey])
    }

    var currentStatusAttributedText: NSAttributedString {
        switch self {
        case .waiting, .declined, .inactive:
            return attributedText
        default:
            let currentStatus = NSMutableAttributedString(string: Constants.currentStatusTitle,
                                                          attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: Constants.fontSize, weight: UIFontWeightLight),
                                                                                                             NSForegroundColorAttributeName: UIColor.warmGrey])
            currentStatus.append(boldAttributedText)
            return currentStatus
        }
    }
}
