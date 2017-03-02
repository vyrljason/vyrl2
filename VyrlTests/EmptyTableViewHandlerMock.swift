//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class EmptyTableViewHandlerMock: EmptyTableViewHandling {
    var currentMode: EmptyCollectionMode?
    var useDidCall = false

    func configure(with mode: EmptyCollectionMode) {
        currentMode = mode
    }

    func use(_ tableView: UITableView) {
        useDidCall = true
    }
}
