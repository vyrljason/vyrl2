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
    private var messageResourceController: APIResourceControllerMock<EmptyResponse>!
    private var imageResourceController: APIResourceControllerMock<InfluencerPost>!

    private var chatPostService: PostService<PostMessageResource>!
    private var imagePostService: PostService<PostImageResource>!

    private var message: String!
    private var collab: Collab!
    private var image: UIImage!

    override func setUp() {
        super.setUp()
        message = "Message"
        collab = VyrlFaker.faker.collab()
        image = UIImage()

        messageResourceController = APIResourceControllerMock<EmptyResponse>()
        messageResourceController.result = EmptyResponse()
        imageResourceController = APIResourceControllerMock<InfluencerPost>()
        imageResourceController.result = VyrlFaker.faker.influencerPost()
        chatPostService = PostService(resource: PostMessageResource(controller: messageResourceController))
        imagePostService = PostService(resource: PostImageResource(controller: imageResourceController))
        imageUploader = ImageUploaderMock()
        imageConverter = ImageToDataConverterMock()

        subject = ImageMessageService(chatPostService: chatPostService, imagePostService: imagePostService,
                                      imageUploader: imageUploader, imageConverter: imageConverter)
    }

    func test_uploadImage_whenConvertAndResourceReturnsSuccess_returnsSuccess() {
        imageUploader.success = true
        imageConverter.success = true
        messageResourceController.success = true
        imageResourceController.success = true

        var wasCalled = false

        subject.send(message: message, withImage: image, toCollab: collab) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenImageUploadReturnsFailure_returnsImageUploadError() {
        imageUploader.success = false
        imageConverter.success = true
        imageResourceController.success = true
        messageResourceController.success = true

        var wasCalled = false

        subject.send(message: message, withImage: image, toCollab: collab) { result in
            wasCalled = true
            expect(result, toBeErrorWith: .imageUpload)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenConversionReturnsError_returnsRelevantError_doesntCallAPI() {
        imageUploader.success = true
        imageConverter.success = false
        imageResourceController.success = true
        messageResourceController.success = true

        var wasCalled = false

        subject.send(message: message, withImage: image, toCollab: collab) { result in
            wasCalled = true
            expect(result, toBeErrorWith: .imageConversion)
        }
        XCTAssertFalse(imageUploader.wasCalled)
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenImagePostReturnsError_returnsRelevantError() {
        imageUploader.success = true
        imageConverter.success = true
        imageResourceController.success = false
        messageResourceController.success = true

        var wasCalled = false

        subject.send(message: message, withImage: image, toCollab: collab) { result in
            wasCalled = true
            expect(result, toBeErrorWith: .imagePost)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_uploadImage_whenMessagePostReturnsError_returnsRelevantError() {
        imageUploader.success = true
        imageConverter.success = true
        imageResourceController.success = true
        messageResourceController.success = false

        var wasCalled = false

        subject.send(message: message, withImage: image, toCollab: collab) { result in
            wasCalled = true
            expect(result, toBeErrorWith: .chatPost)
        }
        XCTAssertTrue(wasCalled)
    }
}
