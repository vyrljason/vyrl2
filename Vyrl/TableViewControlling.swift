//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol TableViewControlling: class {
    func updateTable(with result: DataFetchResult)
    func loadTableData()
}
