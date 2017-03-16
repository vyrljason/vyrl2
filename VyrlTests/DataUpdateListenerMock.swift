//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import Foundation

final class DataUpdateListenerMock: DataLoadingEventsListening {
    var willStart = false
    var didFinish = false

    func willStartDataLoading() {
        willStart = true
    }

    func didFinishDataLoading() {
        didFinish = true
    }
}
