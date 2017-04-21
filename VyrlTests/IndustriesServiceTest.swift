//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class IndustriesServiceTest: XCTestCase {

    private var resourceController: APIResourceControllerMock<Industries>!
    private var resource: IndustriesResource!
    private var subject: IndustriesService!
    private var service: Service<IndustriesResource>!
    
    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<Industries>()
        resourceController.result = Industries(industries: [Industry(id: 0, name: VyrlFaker.faker.lorem.word()),
                                                            Industry(id: 1, name: VyrlFaker.faker.lorem.word()),
                                                            Industry(id: 2, name: VyrlFaker.faker.lorem.word())])
        resource = IndustriesResource(controller: resourceController)
        service = Service<IndustriesResource>(resource: resource)
        subject = IndustriesService(resource: service)
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
