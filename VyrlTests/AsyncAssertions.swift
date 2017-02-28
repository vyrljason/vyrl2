//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import XCTest
@testable import Vyrl

extension XCTestCase {
    func expectToEventuallyBeTrue(_ closure: @autoclosure @escaping (Void) -> Bool, timeout: TimeInterval, checkInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
        let expectation = self.expectation(description: "to eventually be true")
        check(ifTrue: closure, every: checkInterval) { expectation.fulfill() }
        waitForExpectations(timeout: timeout, handler: { error in
            guard let _ = error else { return }
            XCTFail("Expected true", file: file, line: line)
        })
    }

    func check(ifTrue closure: @autoclosure @escaping (Void) -> Bool, every interval: TimeInterval, success: @escaping (Void) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            let isTrue = closure()
            guard isTrue else {
                self.check(ifTrue: closure, every: interval, success: success)
                return
            }
            success()
        }
    }
}
