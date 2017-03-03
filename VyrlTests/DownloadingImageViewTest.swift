//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class DownloadingImageViewTest: XCTestCase {

    var subject: DownloadingImageView!
    var imageFetcher: ImageFetcherMock!
    var placeholder: UIImage!

    override func setUp() {
        placeholder = UIImage()
        imageFetcher = ImageFetcherMock()
        subject = DownloadingImageView(image: nil)
    }

    func test_setImage_withPlaceholder_setsPlaceholder() {
        imageFetcher.success = false

        subject.fetchImage(using: imageFetcher, placeholder: placeholder, animated: false)

        XCTAssertEqual(subject.image, placeholder)
    }

    func test_setImage_withSuccess_setsImage() {
        subject.fetchImage(using: imageFetcher, animated: false)

        XCTAssertEqual(subject.image, imageFetcher.image)
    }

    func test_renderImage_withError_setsNoImage() {
        XCTAssertNil(subject.image)
    }

    func test_setImage_withPlaceholder_withError_setsNoImage_showsPlaceholder() {
        imageFetcher.success = false

        subject.fetchImage(using: imageFetcher, placeholder: placeholder, animated: false)

        XCTAssertEqual(subject.image, placeholder)
    }

    func test_cancelImageFetching_cancelsImageFetching() {
        subject.fetchImage(using: imageFetcher)

        subject.cancelImageFetching(using: nil)

        XCTAssertTrue(imageFetcher.didCancel)
    }

    func test_cancelImageFetching_withPlaceholder_setsPlaceholder() {
        subject.fetchImage(using: imageFetcher)

        subject.cancelImageFetching(using: placeholder)

        XCTAssertEqual(subject.image, placeholder)
    }
}
