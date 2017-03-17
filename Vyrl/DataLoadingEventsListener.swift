//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol DataLoadingEventsListening: class {
    func willStartDataLoading()
    func didFinishDataLoading()
}
