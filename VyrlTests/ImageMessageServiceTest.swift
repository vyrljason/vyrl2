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

final class ImageMessageServiceTest: XCTestCase {

    private var subject: ImageMessageService!
    private var imageUploader: ImageUploaderMock!
    private var imageConverter: ImageToDataConverterMock!
    private var resourceController: APIResourceControllerMock<EmptyResponse>!
    private var postService: PostService<PostMessageResource>!
    private var message: String!
    private var roomId: String!
    private var image: UIImage!

    override func setUp() {
        super.setUp()
        message = "Message"
        roomId = "roomId"
        image = UIImage()

        resourceController = APIResourceControllerMock<EmptyResponse>()
        resourceController.result = EmptyResponse()
        postService = PostService(resource: PostMessageResource(controller: resourceController))
        imageUploader = ImageUploaderMock()
        imageConverter = ImageToDataConverterMock()

        subject = ImageMessageService(postService: postService, imageUploader: imageUploader, imageConverter: imageConverter)
    }

    func test_uploadImage_whenConvertAndResourceReturnsSuccess_returnsSuccess() {
        imageUploader.success = true
        imageConverter.success = true
        resourceController.success = true

        var wasCalled = false

        subject.send(message: message, withImage: image, toRoom: roomId) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenImageUploadReturnsFailure_returnsImageUploadError() {
        imageUploader.success = false
        imageConverter.success = true
        resourceController.success = true

        var wasCalled = false

        subject.send(message: message, withImage: image, toRoom: roomId) { result in
            wasCalled = true
            expect(result, toBeErrorWith: .imageUpload)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenConversionReturnsError_returnsRelevantError_doesntCallAPI() {
        imageUploader.success = true
        imageConverter.success = false
        resourceController.success = true

        var wasCalled = false

        subject.send(message: message, withImage: image, toRoom: roomId) { result in
            wasCalled = true
            expect(result, toBeErrorWith: .imageConversion)
        }
        XCTAssertFalse(imageUploader.wasCalled)
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenPostReturnsError_returnsRelevantError() {
        imageUploader.success = true
        imageConverter.success = true
        resourceController.success = false

        var wasCalled = false

        subject.send(message: message, withImage: image, toRoom: roomId) { result in
            wasCalled = true
            expect(result, toBeErrorWith: .postUpload)
        }
        XCTAssertTrue(wasCalled)
    }
}
