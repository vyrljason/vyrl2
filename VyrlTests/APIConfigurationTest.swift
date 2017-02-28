//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class APIConfigurationTest: XCTestCase {
    private enum DictionaryKeys {
        static let staging = "Staging"
        static let production = "Production"
        static let mainBaseURL = "MainBaseURL"
        static let influencersBaseURL = "InfluencersBaseURL"
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
                                                        mode: .Staging)
            productionConfiguration = try APIConfiguration(bundle: Bundle(for: type(of: self)),
                                                           plistName: Constants.testConfigurationFilename,
                                                           mode: .Production)
        } catch {
            XCTFail()
        }
        guard let filepath = Bundle(for: type(of: self)).path(forResource: Constants.testConfigurationFilename,
                                                          ofType: Constants.fileType) else { XCTFail(); return }
        let plistDictionary = NSDictionary(contentsOfFile: filepath)
        plistStaging = plistDictionary?[DictionaryKeys.staging] as? [String: String]
        plistProduction = plistDictionary?[DictionaryKeys.production] as? [String: String]
    }

    func test_mainBaseURL_WhenModeIsStagingReturnValue() {
        guard let mainBaseURLString = plistStaging?[DictionaryKeys.mainBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: mainBaseURLString)

        XCTAssertEqual(stagingConfiguration?.mainBaseURL, expectedResult)
    }

    func test_mainBaseURL_whenModeIsProduction_ReturnValue() {
        guard let mainBaseURLString = plistProduction?[DictionaryKeys.mainBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: mainBaseURLString)

        XCTAssertEqual(productionConfiguration?.mainBaseURL, expectedResult)
    }

    func test_influencersBaseURL_WhenModeIsStagingReturnValue() {
        guard let influencersBaseURLString = plistStaging?[DictionaryKeys.influencersBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: influencersBaseURLString)

        XCTAssertEqual(stagingConfiguration?.influencersBaseURL, expectedResult)
    }

    func test_influencersBaseURL_whenModeIsProduction_ReturnValue() {
        guard let influencersBaseURLString = plistProduction?[DictionaryKeys.influencersBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: influencersBaseURLString)

        XCTAssertEqual(productionConfiguration?.influencersBaseURL, expectedResult)
    }

    func test_init_WithNoMainBaseURL_throwsError() {
        XCTAssertThrowsError(try APIConfiguration(bundle: Bundle(for: type(of: self)), plistName: Constants.emptyConfigurationFilename))
    }

    func test_init_WithNoExisitingPlist_throwsError() {
        XCTAssertThrowsError(try APIConfiguration(bundle: Bundle(for: type(of: self)), plistName: Constants.fakeConfigurationFilename))
    }
}
