//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ImageUploaderMock: ImageDataUploading {
    var wasCalled = false
    var success = true
    var result = VyrlFaker.faker.imageContainer()
    var error = APIResponseError.connectionProblem

    func upload(imageData: Data, completion: @escaping (Result<ImageContainer, APIResponseError>) -> Void) {
        wasCalled = true
        if success {
            completion(.success(result))
        } else {
            completion(.failure(error))
        }
    }
}

final class ImageToDataConverterMock: ImageToDataConverting {
    var success = true
    var result = Data()

    func convert(image: UIImage) -> Data? {
        return success ? result : nil
    }
}

final class ImageUploadServiceTest: XCTestCase {

    private var subject: ImageUploadService!
    private var resource: ImageUploaderMock!
    private var imageConverter: ImageToDataConverterMock!

    override func setUp() {
        super.setUp()
        resource = ImageUploaderMock()
        imageConverter = ImageToDataConverterMock()
        subject = ImageUploadService(resource: resource, imageConverter: imageConverter)
    }

    func test_uploadImage_whenResourceReturnsFailure_returnsFailure() {
        resource.success = false
        imageConverter.success = true

        let image = UIImage()
        var wasCalled = false

        subject.upload(image: image) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenConvertAndResourceReturnsSuccess_returnsSuccess() {
        resource.success = true
        imageConverter.success = true

        let image = UIImage()
        var wasCalled = false

        subject.upload(image: image) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenConvertReturnsError_returnsFailure_doesntCallAPI() {
        resource.success = true
        imageConverter.success = false
        let image = UIImage()

        subject.upload(image: image) { result in
            expectToBeFailure(result)
        }
        XCTAssertFalse(resource.wasCalled)
    }
}
