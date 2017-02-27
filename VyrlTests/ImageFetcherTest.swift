//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ImageFetchingTest: XCTestCase {

    var subject: ImageFetcher!
    var imageRetriever: ImageRetrieverMock!
    var testURL = URL(string: "https://www.google.com/test.jpg")!

    override func setUp() {
        super.setUp()
        imageRetriever = ImageRetrieverMock()
        subject = ImageFetcher(url: testURL, retriever: imageRetriever)
    }

    func test_fetchImage_withSuccess_returnsImage() {
        subject.fetchImage { result in
            expectToBeSuccess(result)
        }
    }

    func test_fetchImage_withError_returnsError() {
        imageRetriever.success = false

        subject.fetchImage { result in
            expectToBeFailure(result)
        }
    }

    func test_cancel_cancelsDownload() {
        imageRetriever.didFinishCallback = false
        subject.fetchImage { _ in }

        subject.cancel()

        XCTAssertTrue(imageRetriever.lastTask?.cancelDidCall ?? false)
    }
}
