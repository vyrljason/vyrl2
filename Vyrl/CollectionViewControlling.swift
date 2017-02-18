//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum DataFetchResult {
    case someData
    case empty
    case error
}

protocol CollectionViewControlling: class {
    func updateCollection(with result: DataFetchResult)
    func loadData()
}
