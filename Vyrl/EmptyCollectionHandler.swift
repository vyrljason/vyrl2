//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

private enum Constants {
    static let titleAttributes: [String: Any] = [:]
    static let descriptionAttributes: [String: Any] = [:]
    static let noDataTitle = NSLocalizedString("No brands", comment: "")
    static let networkingErrorTitle = NSLocalizedString("Something went wrong", comment: "")
    static let noDataDescription = NSLocalizedString("Sorry, there are no brands at the moment.", comment: "")
    static let networkingErrorDescription = NSLocalizedString("Pull down to refresh.", comment: "")
}

enum EmptyCollectionMode {
    case noData
    case error

    var title: NSAttributedString {
        switch self {
        case .noData:
            return NSAttributedString(string: Constants.noDataTitle, attributes: Constants.titleAttributes)
        case .error:
            return NSAttributedString(string: Constants.networkingErrorTitle, attributes: Constants.titleAttributes)
        }
    }

    var description: NSAttributedString {
        switch self {
        case .noData:
            return NSAttributedString(string: Constants.noDataDescription, attributes: Constants.descriptionAttributes)
        case .error:
            return NSAttributedString(string: Constants.networkingErrorDescription, attributes: Constants.descriptionAttributes)
        }
    }
}

protocol EmptyCollectionViewHandling: CollectionViewUsing {
    func configure(with mode: EmptyCollectionMode)
}

final class EmptyCollectionHandler: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EmptyCollectionViewHandling {
    private weak var collectionView: UICollectionView?
    private var titleText: NSAttributedString?
    private var descriptionText: NSAttributedString?

    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.emptyDataSetSource = self
        self.collectionView?.emptyDataSetDelegate = self
    }

    func configure(with mode: EmptyCollectionMode) {
        titleText = mode.title
        descriptionText = mode.description
    }

    func stopUsingCollectionView() {
        collectionView = nil
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return titleText
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return descriptionText
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return false
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
