//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum CollabStatus: CustomStringConvertible, CustomIntegerConvertible {

    private enum Constants {
        static let currentStatusTitle = NSLocalizedString("messages.currentStatus.title", comment: "")
        static let fontSize: CGFloat = 16
    }

    case brief
    case productDelivery
    case contentReview
    case contentReviewPending
    case contentReviewDeclined
    case publication
    case done
    case waiting
    case inactive
    case custom(String)

    // swiftlint:disable cyclomatic_complexity
    init(apiValue: String) {
        switch apiValue {
        case CollabStatus.brief.apiValue:
            self = .brief
        case CollabStatus.productDelivery.apiValue:
            self = .productDelivery
        case CollabStatus.contentReview.apiValue:
            self = .contentReview
        case CollabStatus.contentReviewPending.apiValue:
            self = .contentReviewPending
        case CollabStatus.contentReviewDeclined.apiValue:
            self = .contentReviewDeclined
        case CollabStatus.publication.apiValue:
            self = .publication
        case CollabStatus.done.apiValue:
            self = .done
        case CollabStatus.waiting.apiValue:
            self = .waiting
        case CollabStatus.inactive.apiValue:
            self = .inactive
        default:
            self = .custom(apiValue)
        }
    }

    static var allValidStatuses: [CollabStatus] {
        return [CollabStatus.brief, CollabStatus.productDelivery, CollabStatus.contentReview,
                CollabStatus.publication, CollabStatus.done]
    }

    var description: String {
        switch self {
        case .brief: return "1. brief"
        case .productDelivery: return "2. productDelivery"
        case .contentReview, .contentReviewPending, .contentReviewDeclined: return "3. contentReview"
        case .publication: return "4. publication"
        case .done: return "5. done"
        case .waiting: return "Waiting for brand response..."
        case .inactive: return "No active collab"
        case .custom(let description): return description
        }
    }
    
    var apiValue: String {
        switch self {
        case .brief: return "ORDER_BRIEF"
        case .productDelivery: return "ORDER_SHIPPED"
        case .contentReview: return "ORDER_CONTENT_NONE"
        case .contentReviewPending: return "ORDER_CONTENT_PENDING"
        case .contentReviewDeclined: return "ORDER_CONTENT_DECLINED"
        case .publication: return "ORDER_CONTENT_APPROVED"
        case .done: return "ORDER_DONE"
        case .waiting: return "WAITING_FOR_BRAND_RESPONSE"
        case .inactive: return "NO_ORDER"
        case .custom: return ""
        }
    }

    var integerValue: Int {
        switch self {
        case .brief:
            return 0
        case .productDelivery:
            return 1
        case .contentReview, .contentReviewPending, .contentReviewDeclined:
            return 2
        case .publication:
            return 3
        case .done:
            return 4
        default:
            return -1
        }
    }

    var isValid: Bool {
        switch self {
        case .waiting, .inactive:
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
        case .waiting, .inactive, .custom:
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

extension CollabStatus: Equatable { }

func == (lhs: CollabStatus, rhs: CollabStatus) -> Bool {
    return lhs.apiValue == rhs.apiValue
}
