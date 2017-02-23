//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Alamofire

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let rootNavigation = RootNavigationBuilder().build()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializeAnalytics()
        setUpAPIConfiguration()
        rootNavigation.showInitialViewController()
        return true
    }

    private func initializeAnalytics() {
        Fabric.with([Crashlytics.self])
    }

    private func setUpAPIConfiguration() {
        guard let apiConfiguration = try? APIConfiguration() else { fatalError("Couldn't retrieve API configuration") }
        let manager = SessionManager()
        let jsonDeserializer = JSONToModelDeserializer()
        let responseHandler = APIResponseHandler(jsonDeserializer: jsonDeserializer)
        let credentialsStorage = CredentialsStorage()
        let credentialsProvider = APICredentialsProvider(storage: credentialsStorage)
        let resourceConfigurator = ResourceConfigurator(configuration: apiConfiguration,
                                                        sessionManager: manager, responseHandler: responseHandler, credentialsProvider: credentialsProvider)
        ServiceLocator.resourceConfigurator = resourceConfigurator
        
    }
}
