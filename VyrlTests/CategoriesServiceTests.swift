//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CategoriesServiceTests: XCTestCase {

    var resourceController: APIResourceControllerMock<Categories>!
    var resource: CategoriesResource!
    var service: Service<CategoriesResource>!
    var subject: CategoriesService!

    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<Categories>()
        resourceController.result = Categories(categories: [])
        resource = CategoriesResource(controller: resourceController)
        service = Service<CategoriesResource>(resource: resource)
        subject = CategoriesService(resource: service)
    }

    func test_get_whenSuccess_returnsCollection() {
        resourceController.success = true

        subject.get { result in
            expectToBeSuccess(result)
        }
    }

    func test_get_whenFailure_returnsError() {
        resourceController.success = false

        subject.get { result in
            expectToBeFailure(result)
        }
    }
}
