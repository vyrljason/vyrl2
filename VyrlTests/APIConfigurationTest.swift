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
        static let FAQURL = "FAQ"
        static let ToSURL = "ToS"
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
        guard let urlString = plistStaging?[DictionaryKeys.mainBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(stagingConfiguration?.mainBaseURL, expectedResult)
    }

    func test_mainBaseURL_whenModeIsProduction_ReturnValue() {
        guard let urlString = plistProduction?[DictionaryKeys.mainBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(productionConfiguration?.mainBaseURL, expectedResult)
    }

    func test_influencersBaseURL_WhenModeIsStagingReturnValue() {
        guard let urlString = plistStaging?[DictionaryKeys.influencersBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(stagingConfiguration?.influencersBaseURL, expectedResult)
    }

    func test_influencersBaseURL_whenModeIsProduction_ReturnValue() {
        guard let urlString = plistProduction?[DictionaryKeys.influencersBaseURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(productionConfiguration?.influencersBaseURL, expectedResult)
    }

    func test_faqURL_WhenModeIsStagingReturnValue() {
        guard let urlString = plistStaging?[DictionaryKeys.FAQURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(stagingConfiguration?.faqURL, expectedResult)
    }

    func test_faqURL_whenModeIsProduction_ReturnValue() {
        guard let urlString = plistProduction?[DictionaryKeys.FAQURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(productionConfiguration?.faqURL, expectedResult)
    }

    func test_tosURL_WhenModeIsStagingReturnValue() {
        guard let urlString = plistStaging?[DictionaryKeys.ToSURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(stagingConfiguration?.tosURL, expectedResult)
    }

    func test_tosURL_whenModeIsProduction_ReturnValue() {
        guard let urlString = plistProduction?[DictionaryKeys.ToSURL] else { XCTFail(); return }
        let expectedResult = URL(string: urlString)

        XCTAssertEqual(productionConfiguration?.tosURL, expectedResult)
    }

    func test_init_WithNoMainBaseURL_throwsError() {
        XCTAssertThrowsError(try APIConfiguration(bundle: Bundle(for: type(of: self)),
                                                  plistName: Constants.emptyConfigurationFilename,
                                                  mode: .Staging))
    }

    func test_init_WithNoExisitingPlist_throwsError() {
        XCTAssertThrowsError(try APIConfiguration(bundle: Bundle(for: type(of: self)),
                                                  plistName: Constants.fakeConfigurationFilename,
                                                  mode: .Staging))
    }
}
