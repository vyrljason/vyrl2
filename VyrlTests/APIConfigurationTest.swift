//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class APIConfigurationTest: XCTestCase {
    private enum DictionaryKeys {
        static let Staging = "Staging"
        static let Production = "Production"
        static let BaseURL = "BaseURL"
    }
    private enum Constants {
        static let testConfigurationFilename = "TestConfiguration"
        static let emptyConfigurationFilename = "EmptyTestConfiguration"
        static let fakeConfigurationFilename = "NonExisitingPlistName"
        static let fileType = "plist"
    }

    private var stagingConfiguration: APIConfiguration?
    private var productionConfiguration: APIConfiguration?
    private var emptyConfiguration: APIConfiguration?
    private var plistStaging: [String: String]?
    private var plistProduction: [String: String]?

    override func setUp() {
        super.setUp()
        do {
            stagingConfiguration = try APIConfiguration(bundle: Bundle(for: type(of: self)),
                                                        plistName: Constants.testConfigurationFilename,
                                                        mode: .staging)
            productionConfiguration = try APIConfiguration(bundle: Bundle(for: type(of: self)),
                                                           plistName: Constants.testConfigurationFilename,
                                                           mode: .production)
        } catch {
            XCTFail()
        }
        guard let filepath = Bundle(for: type(of: self)).path(forResource: Constants.testConfigurationFilename,
                                                          ofType: Constants.fileType) else { XCTFail(); return }
        let plistDictionary = NSDictionary(contentsOfFile: filepath)
        plistStaging = plistDictionary?[DictionaryKeys.Staging] as? [String: String]
        plistProduction = plistDictionary?[DictionaryKeys.Production] as? [String: String]
    }

    func test_baseURL_WhenModeIsStagingReturnValue() {
        guard let baseURLString = plistStaging?[DictionaryKeys.BaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: baseURLString)

        XCTAssertEqual(stagingConfiguration?.baseURL, expectedResult)
    }

    func test_baseURL_whenModeIsProduction_ReturnValue() {
        guard let baseURLString = plistProduction?[DictionaryKeys.BaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: baseURLString)

        XCTAssertEqual(productionConfiguration?.baseURL, expectedResult)
    }

    func test_init_WithNoBaseURL_throwsError() {
        XCTAssertThrowsError(try APIConfiguration(bundle: Bundle(for: type(of: self)), plistName: Constants.emptyConfigurationFilename))
    }

    func test_init_WithNoExisitingPlist_throwsError() {
        XCTAssertThrowsError(try APIConfiguration(bundle: Bundle(for: type(of: self)), plistName: Constants.fakeConfigurationFilename))
    }
}
